defmodule RkvServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :rkv_server,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "./config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools, :rkv],
      env: [routing_table: %{}],
      mod: {RkvServer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rkv_pubsub, in_umbrella: true},
      {:rkv, in_umbrella: true},
      {:phoenix_pubsub_redis, "~> 3.0"}
    ]
  end
end
