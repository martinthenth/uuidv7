defmodule UUIDv7Test do
  use ExUnit.Case

  """
  uuid: 0188e4e0-63d6-7c69-aa53-6daf23d1cfa3
  uuid bytes: [224, 228, 136, 1, 214, 99, 105, 124, 170, 83, 109, 175, 35, 209, 207, 163]
  """

  describe "type/0" do
    test "returns the type" do
      assert UUIDv7.type() == :uuid
    end
  end

  describe "cast/1" do
    test "casts the binary to string" do
      assert UUIDv7.cast(
               <<224, 228, 136, 1, 214, 99, 105, 124, 170, 83, 109, 175, 35, 209, 207, 163>>
             ) ==
               {:ok, "0188e4e0-63d6-7c69-aa53-6daf23d1cfa3"}
    end

    test "casts the string to string" do
      assert UUIDv7.cast("0188e512-3973-73b1-ba3f-06767bf1aad9") ==
               {:ok, "0188e512-3973-73b1-ba3f-06767bf1aad9"}
    end

    test "returns an error when invalid value is given" do
      assert UUIDv7.cast("123") == :error
    end
  end

  describe "dump/2" do
    test "dumps the binary to a binary" do
      assert UUIDv7.dump("0188e4e0-63d6-7c69-aa53-6daf23d1cfa3") ==
               {:ok,
                <<224, 228, 136, 1, 214, 99, 105, 124, 170, 83, 109, 175, 35, 209, 207, 163>>}
    end
  end

  describe "load/1" do
    test "loads the binary into a string" do
      assert UUIDv7.load(
               <<224, 228, 136, 1, 214, 99, 105, 124, 170, 83, 109, 175, 35, 209, 207, 163>>
             ) == {:ok, "0188e4e0-63d6-7c69-aa53-6daf23d1cfa3"}
    end

    test "loads the string into a string" do
      assert_raise ArgumentError, fn ->
        UUIDv7.load("0188e512-3973-73b1-ba3f-06767bf1aad9")
      end
    end
  end

  describe "generate/0" do
    test "generates a string UUID" do
      assert is_binary(UUIDv7.generate())
    end
  end

  describe "bingenerate/0" do
    test "generates a binary UUID" do
      raw_uuid = UUIDv7.bingenerate()
      str_uuid = encode(raw_uuid)

      assert is_binary(str_uuid)
      assert UUIDv7.integration(raw_uuid) == Ecto.UUID.load!(raw_uuid)
    end
  end

  describe "bingenerate_from_ns/1" do
    test "generates an UUID" do
      raw_uuid = UUIDv7.bingenerate_from_ns(1_687_467_090_902)
      str_uuid = encode(raw_uuid)

      assert String.starts_with?(str_uuid, "0188e4e0-63d6-")
      assert UUIDv7.integration(raw_uuid) == Ecto.UUID.load!(raw_uuid)
    end
  end

  describe "autogenerate/0" do
    test "generates a string UUID" do
      assert is_binary(UUIDv7.autogenerate())
    end
  end

  # Changed the encoding to match Rust's Uuid library!
  defp encode(
         <<a1::4, a2::4, a3::4, a4::4, a5::4, a6::4, a7::4, a8::4, b1::4, b2::4, b3::4, b4::4,
           c1::4, c2::4, c3::4, c4::4, d1::4, d2::4, d3::4, d4::4, e1::4, e2::4, e3::4, e4::4,
           e5::4, e6::4, e7::4, e8::4, e9::4, e10::4, e11::4, e12::4>>
       ) do
    <<e(a7), e(a8), e(a5), e(a6), e(a3), e(a4), e(a1), e(a2), ?-, e(b3), e(b4), e(b1), e(b2), ?-,
      e(c3), e(c4), e(c1), e(c2), ?-, e(d1), e(d2), e(d3), e(d4), ?-, e(e1), e(e2), e(e3), e(e4),
      e(e5), e(e6), e(e7), e(e8), e(e9), e(e10), e(e11), e(e12)>>
  end

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

# "0188e50f-e4aa-76ad-b9a2-e23fcfc0d0c3"
# [48, 102, 101, 53, 56, 56, 48, 49, 45, 97, 97, 101, 52, 45, 97, 100, 55, 54, 45, 98, 57, 97, 50, 45, 101, 50, 51, 102, 99, 102, 99, 48, 100, 48, 99, 51]
# ."0188e4e0-63d6-7a24-96ba-3a8b6096ad45"
# [101, 48, 101, 52, 56, 56, 48, 49, 45, 100, 54, 54, 51, 45, 50, 52, 55, 97, 45, 57, 54, 98, 97, 45, 51, 97, 56, 98, 54, 48, 57, 54, 97, 100, 52, 53]

# "0188e512-3973-73b1-ba3f-06767bf1aad9"
# [49, 50, 101, 53, 56, 56, 48, 49, 45, 55, 51, 51, 57, 45, 98, 49, 55, 51, 45, 98, 97, 51, 102, 45, 48, 54, 55, 54, 55, 98, 102, 49, 97, 97, 100, 57]
# ."0188e4e0-63d6-77af-a504-ddd5b6c64cfe"
# [101, 48, 101, 52, 56, 56, 48, 49, 45, 100, 54, 54, 51, 45, 97, 102, 55, 55, 45, 97, 53, 48, 52, 45, 100, 100, 100, 53, 98, 54, 99, 54, 52, 99, 102, 101]
# "e0e48801-d663-af77-a504-ddd5b6c64cfe"
# [101, 48, 101, 52, 56, 56, 48, 49, 45, 100, 54, 54, 51, 45, 97, 102, 55, 55, 45, 97, 53, 48, 52, 45, 100, 100, 100, 53, 98, 54, 99, 54, 52, 99, 102, 101]
