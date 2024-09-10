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
  def generate, do: Ecto.UUID.cast!(bingenerate())

  @doc """
  Generates a version 7 UUID based on the timestamp (ms).
  """
  @spec generate(non_neg_integer()) :: t()
  def generate(milliseconds), do: milliseconds |> bingenerate() |> Ecto.UUID.cast!()

  @doc """
  Generates a version 7 UUID in the binary format.
  """
  @spec bingenerate() :: raw()
  def bingenerate, do: :millisecond |> System.system_time() |> bingenerate()

  @doc """
  Generates a version 7 UUID in the binary format based on the timestamp (ms).
  """
  @spec bingenerate(non_neg_integer()) :: raw()
  def bingenerate(milliseconds) do
    <<u1::12, u2::62, _::6>> = :crypto.strong_rand_bytes(10)
    <<milliseconds::48, 7::4, u1::12, 2::2, u2::62>>
  end

  @doc """
  Extracts the timestamp (ms) from the version 7 UUID.
  """
  @spec timestamp(t() | raw()) :: non_neg_integer()
  def timestamp(<<milliseconds::48, 7::4, _::76>>), do: milliseconds
  def timestamp(<<_::288>> = uuid), do: uuid |> Ecto.UUID.dump!() |> timestamp()
end
