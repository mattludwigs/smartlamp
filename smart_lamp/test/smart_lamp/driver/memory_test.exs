defmodule SmartLamp.Lamp.MemoryTest do
  use ExUnit.Case, async: true

  alias SmartLamp.Lamp.Memory

  describe "initialize the driver" do
    test "with value on" do
      assert {:ok, :on} == Memory.init(:on)
    end

    test "with value off" do
      assert {:ok, :off} == Memory.init(:off)
    end
  end

  describe "toggling" do
    test "from on to off" do
      {:ok, driver_state} = Memory.init(:on)

      assert Memory.toggle(driver_state) == :off
    end

    test "from off to on" do
      {:ok, driver_state} = Memory.init(:off)

      assert Memory.toggle(driver_state) == :on
    end
  end

  describe "get current value" do
    test "get the current value when on" do
      {:ok, driver_state} = Memory.init(:on)

      assert Memory.get_value(driver_state) == :on
    end

    test "get the current value when off" do
      {:ok, driver_state} = Memory.init(:off)

      assert Memory.get_value(driver_state) == :off
    end
  end
end
