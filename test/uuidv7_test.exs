defmodule UUIDv7Test do
  use ExUnit.Case

  describe "add/2" do
    test "adds the numbers" do
      assert UUIDv7.add(1, 3) == 4
    end
  end
end
