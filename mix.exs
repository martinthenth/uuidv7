defmodule UUIDv7.MixProject do
  use Mix.Project

  @version "1.0.0"
  @source_url "https://github.com/martinthenth/uuidv7"
  @changelog_url "https://github.com/martinthenth/uuidv7/blob/main/CHANGELOG.md"

  def project do
    [
      app: :uuidv7,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A UUID v7 implementation and Ecto.Type for Elixir",
      source_ref: @version,
      source_url: @source_url,
      docs: docs(),
      package: package()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:benchee, "~> 1.1", only: :dev},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ecto, "~> 3.12"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:uniq, "~> 0.1", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Martin Nijboer"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url, "Changelog" => @changelog_url}
    ]
  end

  defp docs do
    [main: "UUIDv7", extras: ["README.md"]]
  end
end
