defmodule AshMembership.MixProject do
  use Mix.Project

  @version "1.0.0"
  @source_url "https://github.com/mithereal/ash_membership"

  def project do
    [
      app: :ash_membership,
      version: "1.0.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "A runtime authorization engine for Ash, hot reloadable, abac, query pushdown, policy's"
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README*),
      licenses: ["GPL"],
      links: %{"GitHub" => "https://github.com/mithereal/ash_membership"}
    ]
  end

  defp docs() do
    [
      extras: ["README.md"],
      main: "readme",
      homepage_url: @source_url,
      source_ref: "v#{@version}",
      source_url: @source_url
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.13"},
      {:ash, "~> 3.22"},
      {:ash_authentication, "~> 4.1"},
      {:ash_postgres, "~> 2.0"},
    ]
  end
end
