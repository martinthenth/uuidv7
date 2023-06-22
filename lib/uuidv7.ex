defmodule UUIDv7 do
  @moduledoc """
  Documentation for `UUIDv7`.
  """

  use Rustler, otp_app: :uuidv7, crate: "uuidv7"

  @doc """
  Generates a random, version 7 UUID.

  ## Examples

      iex> UUIDv7.now()
      "0188e521-4eaa-7d2e-8226-824f8122dbf8"

  """
  @spec now :: binary()
  def now(), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Generates a random, version 7 UUID based on the timestamp (ns).

  ## Examples

      iex> UUIDv7.new(1_687_467_090_902)
      "0188e521-4eaa-7d2e-8226-824f8122dbf8"

  """
  @spec new(non_neg_integer()) :: binary()
  def new(_timestamp), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  def integration(_uuid), do: :erlang.nif_error(:nif_not_loaded)
end
