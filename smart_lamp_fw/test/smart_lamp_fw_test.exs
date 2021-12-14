defmodule SmartLampFwTest do
  use ExUnit.Case
  doctest SmartLampFw

  test "greets the world" do
    assert SmartLampFw.hello() == :world
  end
end
