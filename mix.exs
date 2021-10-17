defmodule Rediscl.MixProject do
  use Mix.Project

  def project do
    [
      app: :rediscl,
      version: "0.3.0",
      elixir: "~> 1.10",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.travis": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      package: package(),
      deps: deps(),
      source_url: "https://github.com/akdilsiz/elixir-rediscl"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Rediscl, []},
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", ".formatter.exs", "LICENSE*"],
      maintainers: ["Abdulkadir DILSIZ"],
      licenses: ["MIT"],
      description: "A minimal redis client with connection pooling (using eredis and poolboy)",
      links: %{"GitHub" => "https://github.com/akdilsiz/elixir-rediscl"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:eredis, "~> 1.2"},
      {:poolboy, "~> 1.5"},
      {:excoveralls, "~> 0.14.3", only: :test},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.25.3", only: :dev},
      {:jason, "~> 1.2"}
    ]
  end
end
