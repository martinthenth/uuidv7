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
  def MyApp.Schemas.User do
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
  @spec type() :: :uuid
  def type, do: :uuid

  defdelegate cast(value), to: Ecto.UUID

  defdelegate cast!(value), to: Ecto.UUID

  defdelegate dump(value), to: Ecto.UUID

  defdelegate dump!(value), to: Ecto.UUID

  defdelegate load(value), to: Ecto.UUID

  defdelegate load!(value), to: Ecto.UUID

  @doc false
  @spec autogenerate() :: t()
  def autogenerate, do: generate()

  @doc """
  Generates a version 7 UUID.
  """
  @spec generate() :: t()
  def generate(), do: Ecto.UUID.cast!(bingenerate())

  @doc """
  Generates a version 7 UUID based on the timestamp (ms).
  """
  @spec generate(non_neg_integer()) :: t()
  def generate(ms), do: Ecto.UUID.cast!(bingenerate(ms))

  @doc """
  Generates a version 7 UUID in the binary format.
  """
  @spec bingenerate() :: raw()
  def bingenerate() do
    <<u0::48, _::4, u1::12, _::2, u2::62>> = :crypto.strong_rand_bytes(16)
    <<u0::48, 4::4, u1::12, 2::2, u2::62>>
  end

  @doc """
  Generates a version 7 UUID in the binary format based on the timestamp (ms).
  """
  @spec bingenerate(non_neg_integer()) :: raw()
  def bingenerate(_ms) do
    <<u0::48, _::4, u1::12, _::2, u2::62>> = :crypto.strong_rand_bytes(16)
    <<u0::48, 4::4, u1::12, 2::2, u2::62>>
  end
end
