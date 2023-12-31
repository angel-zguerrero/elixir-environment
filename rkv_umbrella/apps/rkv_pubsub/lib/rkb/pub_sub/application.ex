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
    redis_host_env = System.get_env("REDIS_HOST")
    redis_port_env = System.get_env("REDIS_PORT")

    redis_host = case redis_host_env do
      :nil -> "elixir-redis"
      _ -> redis_host_env
    end

    redis_port = case redis_port_env do
      :nil -> 6379
      _ -> String.to_integer(redis_port_env)
    end

    children = [
      {Phoenix.PubSub,
       name: Rkb.PubSub.Service,
       adapter: Phoenix.PubSub.Redis, host: redis_host, port: redis_port, node_name: System.get_env("NODE")}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rkb.PubSub.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
