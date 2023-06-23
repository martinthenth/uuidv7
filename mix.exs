defmodule UUIDv7.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/martinthenth/uuidv7"
  @changelog_url "https://github.com/martinthenth/uuidv7/blob/main/CHANGELOG.md"

  def project do
    [
      app: :uuidv7,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A UUID version 7 implementation and Ecto.Type for Elixir - based on Rust",
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
      {:rustler, "~> 0.29.0"},
      {:ecto, "~> 3.10"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:benchee, "~> 1.1", only: :dev},
      {:uniq, "~> 0.1", only: :dev},
      {:rustler_precompiled, "~> 0.6"}
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
    [
      main: "UUIDv7",
      extras: ["README.md"]
    ]
  end
end
