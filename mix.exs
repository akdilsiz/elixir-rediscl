defmodule Rediscl.MixProject do
  use Mix.Project

  def project do
    [
      app: :rediscl,
      version: "0.1.3",
      elixir: "~> 1.6",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.travis": :test,  "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
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
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Abdulkadir DILSIZ"],
      licenses: ["MIT"],
      description: "A minimal redis client for elixir",
      links:  %{"GitHub" => "https://github.com/akdilsiz/elixir-rediscl"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:exredis, ">= 0.2.4"},
      {:poolboy, "~> 1.5"},
      {:excoveralls, "~> 0.8", only: :test},
      {:credo, "~> 0.9.1", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.14", only: :dev}
    ]
  end
end
