defmodule UUIDv7.MixProject do
  use Mix.Project

  @version "0.2.2"
  @source_url "https://github.com/martinthenth/uuidv7"
  @changelog_url "https://github.com/martinthenth/uuidv7/blob/main/CHANGELOG.md"

  def project do
    [
      app: :uuidv7,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A UUID v7 implementation and Ecto.Type for Elixir - based on Rust",
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
      {:ecto, "~> 3.10"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:rustler, "~> 0.30.0", optional: true},
      {:rustler_precompiled, "~> 0.7"},
      {:uniq, "~> 0.1", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Martin Nijboer"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url, "Changelog" => @changelog_url},
      files: [
        "lib",
        "native/uuidv7/.cargo",
        "native/uuidv7/src",
        "native/uuidv7/Cargo*",
        "checksum-*.exs",
        ".formatter.exs",
        "mix.exs",
        "README*",
        "LICENSE*",
        "CHANGELOG*"
      ]
    ]
  end

  defp docs do
    [
      main: "UUIDv7",
      extras: ["README.md"]
    ]
  end
end
