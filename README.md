# UUIDv7

A UUID v7 implementation and `Ecto.Type` for Elixir - based on Rust.

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
  [{:uuidv7, "~> 0.2.0"}]
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
