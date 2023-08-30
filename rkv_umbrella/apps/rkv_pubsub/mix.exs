defmodule Rkb.PubSub.MixProject do
  use Mix.Project

  def project do
    [
      app: :rkv_pubsub,
      version: "0.1.0",
      build_path: "../../_build",
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
      extra_applications: [:logger],
      mod: {Rkb.PubSub.Application, []},
      applications: [:phoenix_pubsub_redis]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_pubsub_redis, "~> 3.0"}
    ]
  end
end
