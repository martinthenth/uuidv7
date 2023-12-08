defmodule UUIDv7 do
  @moduledoc """
  A UUID v7 implementation and `Ecto.Type` for Elixir - based on Rust.

  This library defers the UUID v7 implementation to the Rust create [UUID](https://crates.io/crates/uuid)
  using an Erlang NIF. It includes an `Ecto.Type` to (auto-)generate version 7 UUIDs in `Ecto.Schema` and beyond.

  Thanks to Rust, it is ~72% faster in generating version 7 UUIDs than the Elixir implementation
  of version 4 UUIDs by Ecto. See the benchmarks for more details.

  ## Installation

  The package can be installed by adding `uuidv7` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:uuidv7, "~> 0.2"}]
  end
  ```

  ## Usage

  In your database schema, change primary key attribute from `:binary_id` to `UUIDv7`:

  ```elixir
  def App.Schemas.User do
    @primary_key {:id, UUIDv7, autogenerate: true}
  end
  ```

  ## Benchmark

  Run `mix deps.get` and then `mix run scripts/bench.exs` to run the benchmark on your computer.

  ```zsh
  Operating System: macOS
  CPU Information: Apple M2 Pro
  Number of Available Cores: 10
  Available memory: 16 GB
  Elixir 1.14.2
  Erlang 25.1.2

  Benchmark suite executing with the following configuration:
  warmup: 5 s
  time: 10 s
  memory time: 5 s
  reduction time: 0 ns
  parallel: 1
  inputs: none specified
  Estimated total run time: 1 min

  Benchmarking ecto (uuid v4) ...
  Benchmarking uniq (uuid v7) ...
  Benchmarking uuidv7 ...

  Name                     ips        average  deviation         median         99th %
  uuidv7                1.75 M      570.22 ns  ±3940.19%         500 ns         667 ns
  uniq (uuid v7)        1.07 M      937.20 ns  ±1852.78%         916 ns        1000 ns
  ecto (uuid v4)        1.02 M      978.17 ns  ±1593.54%         958 ns        1042 ns

  Comparison:
  uuidv7                1.75 M
  uniq (uuid v7)        1.07 M - 1.64x slower +366.98 ns
  ecto (uuid v4)        1.02 M - 1.72x slower +407.95 ns

  Memory usage statistics:

  Name                   average  deviation         median         99th %
  uuidv7                   104 B     ±0.00%          104 B          104 B
  uniq (uuid v7)        214.00 B     ±2.47%          216 B          216 B
  ecto (uuid v4)        214.00 B     ±2.47%          216 B          216 B

  Comparison:
  uuidv7                   104 B
  uniq (uuid v7)        214.00 B - 2.06x memory usage +110.00 B
  ecto (uuid v4)        214.00 B - 2.06x memory usage +110.00 B
  ```

  ## Credits

  This library is based on the Rust library [UUID](https://crates.io/crates/uuid). Thank you!

  The `Ecto.Type` is heavily borrowed from from [Ecto](https://github.com/elixir-ecto/ecto). Thanks!
  """

  @version Mix.Project.config()[:version]

  use RustlerPrecompiled,
    otp_app: :uuidv7,
    crate: "uuidv7",
    base_url: "https://github.com/martinthenth/uuidv7/releases/download/v#{@version}",
    targets: [
      "aarch64-unknown-linux-gnu",
      "aarch64-apple-darwin",
      "riscv64gc-unknown-linux-gnu",
      "x86_64-apple-darwin",
      "x86_64-unknown-linux-gnu",
      "x86_64-unknown-linux-musl"
    ],
    nif_versions: ["2.16"],
    force_build: System.get_env("FORCE_BUILD") in ["1", "true"],
    version: @version

  use UUIDv7.Type

  @doc """
  Generates a version 7 UUID.
  """
  @spec generate() :: t()
  def generate, do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Generates a version 7 UUID based on the timestamp (ms).
  """
  @spec generate(non_neg_integer()) :: t()
  def generate(ms), do: generate_from_ms(ms)

  @doc """
  Generates a version 7 UUID based on the timestamp (ms).
  """
  @spec generate_from_ms(non_neg_integer()) :: t()
  def generate_from_ms(_ms), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec autogenerate() :: t()
  def autogenerate, do: generate()
end
