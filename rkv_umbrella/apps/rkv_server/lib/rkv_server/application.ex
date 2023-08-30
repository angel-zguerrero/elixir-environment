defmodule RkvServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    if node() == :nonode@nohost do
      exit("sname is required for start rkv_server applicacion")
    end
    children = [
      Supervisor.child_spec({Task, fn -> RkvServer.TcpServer.accept(4040) end}, restart: :permanent),
      {Task.Supervisor, name: Rkv.TaskSupervisorClient, strategy: :one_for_one},
      {RkvServer.WorkerRegistryListener, strategy: :one_for_one}
    ]
    # Use this command to suscribe automatically to the registers table
    # Phoenix.PubSub.broadcast(Rkv.Server.PubSub, "worker:registry:listener", node())
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RkvServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
