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
             ) ==
               {:ok, "0188e590-0dca-7ced-a90d-c3838376becb"}
    end

    test "casts the string to string" do
      assert UUIDv7.cast("0188e590-0dca-7ced-a90d-c3838376becb") ==
               {:ok, "0188e590-0dca-7ced-a90d-c3838376becb"}
    end

    test "returns an error when invalid value is given" do
      assert UUIDv7.cast("123") == :error
    end
  end

  describe "dump/2" do
    test "dumps the string to a binary" do
      assert UUIDv7.dump("0188e590-0dca-7ced-a90d-c3838376becb") ==
               {:ok,
                <<1, 136, 229, 144, 13, 202, 124, 237, 169, 13, 195, 131, 131, 118, 190, 203>>}
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

  describe "generate/0" do
    test "generates a string UUID" do
      assert is_binary(UUIDv7.generate())
    end
  end

  describe "bingenerate/0" do
    test "generates a binary UUID" do
      raw_uuid = UUIDv7.bingenerate()
      str_uuid = UUIDv7.load!(raw_uuid)

      assert is_binary(str_uuid)
      assert UUIDv7.dump!(str_uuid) == raw_uuid
    end
  end

  describe "bingenerate_from_ns/1" do
    test "generates an UUID" do
      raw_uuid = UUIDv7.bingenerate_from_ns(1_687_467_090_902)
      str_uuid = UUIDv7.load!(raw_uuid)

      assert String.starts_with?(str_uuid, "0188e4e0-63d6-")
      assert UUIDv7.dump!(str_uuid) == raw_uuid
    end
  end

  describe "autogenerate/0" do
    test "generates a string UUID" do
      assert is_binary(UUIDv7.autogenerate())
    end
  end
end
