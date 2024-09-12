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
               <<1, 136, 229, 144, 13, 202, 124, 237, 169, 13, 195, 131, 131, 118, 190, 203>>
             ) == {:ok, "0188e590-0dca-7ced-a90d-c3838376becb"}
    end

    test "casts the string to string" do
      assert UUIDv7.cast("0188e590-0dca-7ced-a90d-c3838376becb") ==
               {:ok, "0188e590-0dca-7ced-a90d-c3838376becb"}
    end

    test "returns an error when invalid value is given" do
      assert UUIDv7.cast("123") == :error
    end
  end

  describe "cast!/1" do
    test "casts the binary to string" do
      assert UUIDv7.cast!(
               <<1, 136, 229, 144, 13, 202, 124, 237, 169, 13, 195, 131, 131, 118, 190, 203>>
             ) == "0188e590-0dca-7ced-a90d-c3838376becb"
    end
  end

  describe "dump/1" do
    test "dumps the string to a binary" do
      assert UUIDv7.dump("0188e590-0dca-7ced-a90d-c3838376becb") ==
               {:ok,
                <<1, 136, 229, 144, 13, 202, 124, 237, 169, 13, 195, 131, 131, 118, 190, 203>>}
    end
  end

  describe "dump!/1" do
    test "dumps the string to a binary" do
      assert UUIDv7.dump!("0188e590-0dca-7ced-a90d-c3838376becb") ==
               <<1, 136, 229, 144, 13, 202, 124, 237, 169, 13, 195, 131, 131, 118, 190, 203>>
    end
  end

  describe "load/1" do
    test "loads the binary into a string" do
      assert UUIDv7.load(
               <<1, 136, 229, 144, 13, 202, 124, 237, 169, 13, 195, 131, 131, 118, 190, 203>>
             ) == {:ok, "0188e590-0dca-7ced-a90d-c3838376becb"}
    end

    test "loads the string into a string" do
      assert_raise ArgumentError, fn ->
        UUIDv7.load("0188e590-0dca-7ced-a90d-c3838376becb")
      end
    end
  end

  describe "load!/1" do
    test "loads the binary into a string" do
      assert UUIDv7.load!(
               <<1, 136, 229, 144, 13, 202, 124, 237, 169, 13, 195, 131, 131, 118, 190, 203>>
             ) == "0188e590-0dca-7ced-a90d-c3838376becb"
    end
  end

  describe "autogenerate/0" do
    test "generates a string uuid" do
      assert <<_::288>> = UUIDv7.autogenerate()
    end
  end

  describe "generate/0" do
    test "generates a string uuid" do
      assert <<_::288>> = UUIDv7.generate()
    end

    test "is lexicographically sortable" do
      uuid1 = UUIDv7.generate()
      Process.sleep(1)
      uuid2 = UUIDv7.generate()
      Process.sleep(1)
      uuid3 = UUIDv7.generate()
      Process.sleep(1)
      uuid4 = UUIDv7.generate()

      assert uuid1 < uuid2
      assert uuid2 < uuid3
      assert uuid3 < uuid4
    end
  end

  describe "generate/1" do
    test "generates a binary uuid" do
      assert "0188e4e0-63d6-7" <> _ = UUIDv7.generate(1_687_467_090_902)
    end

    test "is lexicographically sortable" do
      uuid1 = UUIDv7.generate(1_687_467_090_901)
      uuid2 = UUIDv7.generate(1_687_467_090_902)
      uuid3 = UUIDv7.generate(1_687_467_090_903)
      uuid4 = UUIDv7.generate(1_687_467_090_904)

      assert uuid1 < uuid2
      assert uuid2 < uuid3
      assert uuid3 < uuid4
    end
  end

  describe "bingenerate/0" do
    test "generates a byte array uuid" do
      assert <<_::48, 7::4, _::12, 2::2, _::62>> = UUIDv7.bingenerate()
    end
  end

  describe "bingenerate/1" do
    test "generates a byte array uuid" do
      raw_uuid = UUIDv7.bingenerate(1_687_467_090_902)
      str_uuid = UUIDv7.load!(raw_uuid)

      assert <<_::48, 7::4, _::12, 2::2, _::62>> = raw_uuid
      assert "0188e4e0-63d6-7" <> _ = str_uuid
    end
  end

  describe "timestamp/1" do
    test "returns the timestamp for a bytes uuid" do
      raw_uuid = UUIDv7.bingenerate(1_687_467_090_902)

      assert UUIDv7.timestamp(raw_uuid) == 1_687_467_090_902
    end

    test "returns the timestamp for a string uuid" do
      str_uuid = UUIDv7.generate(1_687_467_090_902)

      assert UUIDv7.timestamp(str_uuid) == 1_687_467_090_902
    end

    test "returns the timestamp for an uppercased string uuid" do
      str_uuid = 1_687_467_090_902 |> UUIDv7.generate() |> String.upcase()

      assert UUIDv7.timestamp(str_uuid) == 1_687_467_090_902
    end
  end

  describe "compliance" do
    test "trailing numbers" do
      Enum.reduce(0..65_535, "", fn i, prev_uuid ->
        uuid = UUIDv7.generate(i)

        d1 = div(i, 4096) |> rem(16)
        d2 = div(i, 256) |> rem(16)
        d3 = div(i, 16) |> rem(16)
        d4 = rem(i, 16)

        assert String.starts_with?(uuid, "00000000-#{e(d1)}#{e(d2)}#{e(d3)}#{e(d4)}-7")
        assert uuid > prev_uuid

        uuid
      end)
    end

    test "hourly numbers" do
      timestamp_1 = 1_725_981_620_571
      timestamp_2 = timestamp_1 + 60 * 60 * 1000
      timestamp_3 = timestamp_2 + 60 * 60 * 1000
      timestamp_4 = timestamp_3 + 60 * 60 * 1000

      assert "0191dc85-795b-7" <> _ = UUIDv7.generate(timestamp_1)
      assert "0191dcbc-67db-7" <> _ = UUIDv7.generate(timestamp_2)
      assert "0191dcf3-565b-7" <> _ = UUIDv7.generate(timestamp_3)
      assert "0191dd2a-44db-7" <> _ = UUIDv7.generate(timestamp_4)
    end

    test "power of ten numbers" do
      assert "00000001-86a0-7" <> _ = UUIDv7.generate(100_000)
      assert "0000000f-4240-7" <> _ = UUIDv7.generate(1_000_000)
      assert "00000098-9680-7" <> _ = UUIDv7.generate(10_000_000)
      assert "000005f5-e100-7" <> _ = UUIDv7.generate(100_000_000)
      assert "00003b9a-ca00-7" <> _ = UUIDv7.generate(1_000_000_000)
      assert "0002540b-e400-7" <> _ = UUIDv7.generate(10_000_000_000)
      assert "00174876-e800-7" <> _ = UUIDv7.generate(100_000_000_000)
      assert "00e8d4a5-1000-7" <> _ = UUIDv7.generate(1_000_000_000_000)
      assert "09184e72-a000-7" <> _ = UUIDv7.generate(10_000_000_000_000)
      assert "5af3107a-4000-7" <> _ = UUIDv7.generate(100_000_000_000_000)
    end
  end

  defp e(0), do: "0"
  defp e(1), do: "1"
  defp e(2), do: "2"
  defp e(3), do: "3"
  defp e(4), do: "4"
  defp e(5), do: "5"
  defp e(6), do: "6"
  defp e(7), do: "7"
  defp e(8), do: "8"
  defp e(9), do: "9"
  defp e(10), do: "a"
  defp e(11), do: "b"
  defp e(12), do: "c"
  defp e(13), do: "d"
  defp e(14), do: "e"
  defp e(15), do: "f"
end
