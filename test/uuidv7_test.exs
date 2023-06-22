defmodule UUIDv7Test do
  use ExUnit.Case

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
    test "dumps the string to a binary" do
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
