defmodule UUIDv7Test do
  use ExUnit.Case

  describe "add/2" do
    test "adds the numbers" do
      assert UUIDv7.add(1, 3) == 4
    end
  end

  describe "generate/0" do
    test "generates an UUID" do
      assert is_binary(UUIDv7.generate())

      IO.inspect(UUIDv7.generate())
    end
  end
end
