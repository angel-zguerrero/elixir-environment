defmodule RkvServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # testing callig rkv app
    {:ok, bucket} = Rkv.Bucket.start_link([])
    IO.inspect(bucket)

    children = [
      # Starts a worker by calling: RkvServer.Worker.start_link(arg)
      # {RkvServer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RkvServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
