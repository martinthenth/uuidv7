# UUIDv7

A UUID v7 implementation and `Ecto.Type` for Elixir.

The RFC for the version 7 UUID: [RFC 9562](https://datatracker.ietf.org/doc/rfc9562/).

This library includes an `Ecto.Type` to (auto-)generate version 7 UUIDs in `Ecto.Schema` and beyond.

## Installation

The package can be installed by adding `uuidv7` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:uuidv7, "~> 1.0"}]
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
Elixir 1.17.2
Erlang 27.0.1
JIT enabled: true

Benchmark suite executing with the following configuration:
warmup: 5 s
time: 10 s
memory time: 5 s
reduction time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 1 min

Name                     ips        average  deviation         median         99th %
uuidv7                1.82 M      550.49 ns ±15102.40%         417 ns        1291 ns
uniq (uuid v7)        1.80 M      554.54 ns ±19362.74%         417 ns        1292 ns
ecto (uuid v4)        1.72 M      579.75 ns ±12640.39%         458 ns        1208 ns

Comparison:
uuidv7                1.82 M
uniq (uuid v7)        1.80 M - 1.01x slower +4.05 ns
ecto (uuid v4)        1.72 M - 1.05x slower +29.25 ns

Memory usage statistics:

Name                   average  deviation         median         99th %
uuidv7                237.99 B     ±2.23%          240 B          240 B
uniq (uuid v7)        214.01 B     ±2.47%          216 B          216 B
ecto (uuid v4)        214.01 B     ±2.47%          216 B          216 B

Comparison:
uuidv7                   240 B
uniq (uuid v7)        214.01 B - 0.90x memory usage -23.98508 B
ecto (uuid v4)        214.01 B - 0.90x memory usage -23.98596 B
```
