defmodule Rkv.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  def heartBeat() do
    Process.sleep(1000)
    Phoenix.PubSub.broadcast(Rkb.PubSub.Service, "worker:registry:listener", [node: node()])
    heartBeat()
  end
  @impl true
  def start(_type, _args) do
    if node() == :nonode@nohost do
      exit("sname is required for start rkv applicacion")
    end
    children = [
      {Rkv.Registry, [name: Rkv.Registry, strategy: :one_for_rest]},
      {DynamicSupervisor, name: KV.BucketSupervisor, strategy: :one_for_one},
      Supervisor.child_spec(
        {
          Task,
          fn ->
            heartBeat()
          end
        },
        restart: :permanent
      ),
      {Task.Supervisor, name: Rkv.TaskRemoteCaller}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rkv.Supervisor]
    res = Supervisor.start_link(children, opts)

    # Phoenix.PubSub.broadcast(PubSub.Rkv, "worker:registry:listener", node())
    res
  end
end
