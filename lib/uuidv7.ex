defmodule UUIDv7 do
  @moduledoc """
  A UUID v7 implementation and `Ecto.Type` for Elixir

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
  """

  use Ecto.Type

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

  defdelegate cast(value), to: Ecto.UUID

  defdelegate cast!(value), to: Ecto.UUID

  defdelegate dump(value), to: Ecto.UUID

  defdelegate dump!(value), to: Ecto.UUID

  defdelegate load(value), to: Ecto.UUID

  defdelegate load!(value), to: Ecto.UUID

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
