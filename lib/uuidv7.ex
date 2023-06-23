defmodule UUIDv7 do
  @moduledoc """
  A UUID version 7 implementation and `Ecto.Type` for Elixir - based on Rust.

  This library defers the UUID v7 implementation to the Rust create [UUID](https://crates.io/crates/uuid)
  using an Erlang NIF. It includes an `Ecto.Type` to (auto-)generate version 7 UUIDs in `Ecto.Schema` and beyond.

  Thanks to Rust, it is ~72% faster in generating version 7 UUIDs than the Elixir implementation
  of version 4 UUIDs by Ecto. See the benchmarks for more details.

  > The underlying Rust library marks the v7 UUID implementation as experimental, so please be aware
  > that it _could_ change; but you will be notified of that in the [CHANGELOG](https://github.com/martinthenth/uuidv7/blob/main/CHANGELOG.md). (23-06-2023)

  ## Installation

  The package can be installed by adding `uuidv7` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:uuidv7, "~> 0.1.0"}]
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
  version = Mix.Project.config()[:version]

  use Ecto.Type

  use RustlerPrecompiled,
    otp_app: :uuidv7,
    crate: "uuidv7",
    base_url: "https://github.com/martinthenth/uuidv7/releases/download/v#{version}",
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
    version: version

  @typedoc """
  A hex-encoded UUID string.
  """
  @type t :: <<_::288>>

  @typedoc """
  A raw binary representation of a UUID.
  """
  @type raw :: <<_::128>>

  @doc false
  def type, do: :uuid

  @doc """
  Casts to a UUID.
  """
  @spec cast(t() | raw() | any()) :: {:ok, t()} | :error
  def cast(
        <<a1, a2, a3, a4, a5, a6, a7, a8, ?-, b1, b2, b3, b4, ?-, c1, c2, c3, c4, ?-, d1, d2, d3,
          d4, ?-, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12>>
      ) do
    <<c(a1), c(a2), c(a3), c(a4), c(a5), c(a6), c(a7), c(a8), ?-, c(b1), c(b2), c(b3), c(b4), ?-,
      c(c1), c(c2), c(c3), c(c4), ?-, c(d1), c(d2), c(d3), c(d4), ?-, c(e1), c(e2), c(e3), c(e4),
      c(e5), c(e6), c(e7), c(e8), c(e9), c(e10), c(e11), c(e12)>>
  catch
    :error -> :error
  else
    hex_uuid -> {:ok, hex_uuid}
  end

  def cast(<<_::128>> = raw_uuid), do: {:ok, encode(raw_uuid)}
  def cast(_), do: :error

  @doc """
  Same as `cast/1` but raises `Ecto.CastError` on invalid arguments.
  """
  @spec cast!(t() | raw() | any()) :: t()
  def cast!(value) do
    case cast(value) do
      {:ok, hex_uuid} -> hex_uuid
      :error -> raise Ecto.CastError, type: __MODULE__, value: value
    end
  end

  @compile {:inline, c: 1}

  defp c(?0), do: ?0
  defp c(?1), do: ?1
  defp c(?2), do: ?2
  defp c(?3), do: ?3
  defp c(?4), do: ?4
  defp c(?5), do: ?5
  defp c(?6), do: ?6
  defp c(?7), do: ?7
  defp c(?8), do: ?8
  defp c(?9), do: ?9
  defp c(?A), do: ?a
  defp c(?B), do: ?b
  defp c(?C), do: ?c
  defp c(?D), do: ?d
  defp c(?E), do: ?e
  defp c(?F), do: ?f
  defp c(?a), do: ?a
  defp c(?b), do: ?b
  defp c(?c), do: ?c
  defp c(?d), do: ?d
  defp c(?e), do: ?e
  defp c(?f), do: ?f
  defp c(_), do: throw(:error)

  @doc """
  Converts a string representing a UUID into a raw binary.
  """
  @spec dump(t() | any()) :: {:ok, raw()} | :error
  def dump(
        <<a1, a2, a3, a4, a5, a6, a7, a8, ?-, b1, b2, b3, b4, ?-, c1, c2, c3, c4, ?-, d1, d2, d3,
          d4, ?-, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12>>
      ) do
    <<d(a1)::4, d(a2)::4, d(a3)::4, d(a4)::4, d(a5)::4, d(a6)::4, d(a7)::4, d(a8)::4, d(b1)::4,
      d(b2)::4, d(b3)::4, d(b4)::4, d(c1)::4, d(c2)::4, d(c3)::4, d(c4)::4, d(d1)::4, d(d2)::4,
      d(d3)::4, d(d4)::4, d(e1)::4, d(e2)::4, d(e3)::4, d(e4)::4, d(e5)::4, d(e6)::4, d(e7)::4,
      d(e8)::4, d(e9)::4, d(e10)::4, d(e11)::4, d(e12)::4>>
  catch
    :error -> :error
  else
    raw_uuid -> {:ok, raw_uuid}
  end

  def dump(_), do: :error

  @compile {:inline, d: 1}

  defp d(?0), do: 0
  defp d(?1), do: 1
  defp d(?2), do: 2
  defp d(?3), do: 3
  defp d(?4), do: 4
  defp d(?5), do: 5
  defp d(?6), do: 6
  defp d(?7), do: 7
  defp d(?8), do: 8
  defp d(?9), do: 9
  defp d(?A), do: 10
  defp d(?B), do: 11
  defp d(?C), do: 12
  defp d(?D), do: 13
  defp d(?E), do: 14
  defp d(?F), do: 15
  defp d(?a), do: 10
  defp d(?b), do: 11
  defp d(?c), do: 12
  defp d(?d), do: 13
  defp d(?e), do: 14
  defp d(?f), do: 15
  defp d(_), do: throw(:error)

  @doc """
  Same as `dump/1` but raises `Ecto.ArgumentError` on invalid arguments.
  """
  @spec dump!(t() | any()) :: raw()
  def dump!(value) do
    case dump(value) do
      {:ok, raw_uuid} -> raw_uuid
      :error -> raise ArgumentError, "cannot dump given UUID to binary: #{inspect(value)}"
    end
  end

  @doc """
  Converts a binary UUID into a string.
  """
  @spec load(raw() | any()) :: {:ok, t()} | :error
  def load(<<_::128>> = raw_uuid), do: {:ok, encode(raw_uuid)}

  def load(<<_::64, ?-, _::32, ?-, _::32, ?-, _::32, ?-, _::96>> = string) do
    raise ArgumentError,
          "trying to load string UUID as Ecto.UUID: #{inspect(string)}. " <>
            "Maybe you wanted to declare :uuid as your database field?"
  end

  def load(_), do: :error

  @doc """
  Same as `load/1` but raises `Ecto.ArgumentError` on invalid arguments.
  """
  @spec load!(raw() | any()) :: t()
  def load!(value) do
    case load(value) do
      {:ok, hex_uuid} -> hex_uuid
      :error -> raise ArgumentError, "cannot load given binary as UUID: #{inspect(value)}"
    end
  end

  @doc """
  Generates a random, version 7 UUID.
  """
  @spec generate() :: raw()
  def generate, do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Generates a random, version 7 UUID based on the timestamp (ns).
  """
  def generate(nanoseconds), do: generate_from_ns(nanoseconds)

  @doc false
  @spec generate_from_ns(non_neg_integer()) :: raw()
  def generate_from_ns(_nanoseconds), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec autogenerate() :: binary()
  def autogenerate, do: generate()

  @spec encode(raw) :: t
  defp encode(
         <<a1::4, a2::4, a3::4, a4::4, a5::4, a6::4, a7::4, a8::4, b1::4, b2::4, b3::4, b4::4,
           c1::4, c2::4, c3::4, c4::4, d1::4, d2::4, d3::4, d4::4, e1::4, e2::4, e3::4, e4::4,
           e5::4, e6::4, e7::4, e8::4, e9::4, e10::4, e11::4, e12::4>>
       ) do
    <<e(a1), e(a2), e(a3), e(a4), e(a5), e(a6), e(a7), e(a8), ?-, e(b1), e(b2), e(b3), e(b4), ?-,
      e(c1), e(c2), e(c3), e(c4), ?-, e(d1), e(d2), e(d3), e(d4), ?-, e(e1), e(e2), e(e3), e(e4),
      e(e5), e(e6), e(e7), e(e8), e(e9), e(e10), e(e11), e(e12)>>
  end

  @compile {:inline, e: 1}

  defp e(0), do: ?0
  defp e(1), do: ?1
  defp e(2), do: ?2
  defp e(3), do: ?3
  defp e(4), do: ?4
  defp e(5), do: ?5
  defp e(6), do: ?6
  defp e(7), do: ?7
  defp e(8), do: ?8
  defp e(9), do: ?9
  defp e(10), do: ?a
  defp e(11), do: ?b
  defp e(12), do: ?c
  defp e(13), do: ?d
  defp e(14), do: ?e
  defp e(15), do: ?f
end
