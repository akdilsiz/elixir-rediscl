defmodule Rediscl.MixProject do
  use Mix.Project

  def project do
    [
      app: :rediscl,
      version: "0.1.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      packages: packages(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Rediscl, []},
      extra_applications: [:logger]
    ]
  end

  defp packages do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Abdulkadir DILSIZ"],
      licenses: ["MIT"],
      links:  %{"GitHub" => "https://github.com/akdilsiz/elixir-rediscl"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:exredis, ">= 0.2.4"},
      {:poolboy, "~> 1.5"},
      {:excoveralls, "~> 0.8", only: :test},
      {:credo, "~> 0.9.1", only: [:dev, :test], runtime: false}
    ]
  end
end
