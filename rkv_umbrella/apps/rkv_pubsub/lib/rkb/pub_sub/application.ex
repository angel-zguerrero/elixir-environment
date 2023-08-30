defmodule Rkb.PubSub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    if node() == :nonode@nohost do
      exit("sname is required for start rkv_pubsub applicacion")
    end
    children = [
      {Phoenix.PubSub,
       name: Rkb.PubSub.Service,
       adapter: Phoenix.PubSub.Redis, host: "elixir-redis", node_name: System.get_env("NODE")}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rkb.PubSub.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
