defmodule UUIDv7 do
  @moduledoc """
  Documentation for `UUIDv7`.
  """

  use Rustler, otp_app: :uuidv7, crate: "uuidv7"

  @doc """
  Hello world.

  ## Examples

      iex> UUIDv7.hello()
      :world

  """
  # When your NIF is loaded, it will override this function.
  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)
end
