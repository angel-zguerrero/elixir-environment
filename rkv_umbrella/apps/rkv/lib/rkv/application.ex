defmodule Rkv.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Rkv.Registry, [name: Rkv.Registry, strategy: :one_for_rest]},
      {DynamicSupervisor, name: KV.BucketSupervisor, strategy: :one_for_one},
      {Phoenix.PubSub, name: Rkv.PubSub}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rkv.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
