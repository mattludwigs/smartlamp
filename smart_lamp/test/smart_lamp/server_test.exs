defmodule SmartLamp.ServerTest do
  use ExUnit.Case, async: true

  alias SmartLamp.Server

  test "can toggle the LED state" do
    {:ok, server} = Server.start_link(name: :server_toggle_test)

    init_value = Server.get_value(server)

    # Server should set the lamp to off if no initial value is provided
    assert init_value == :off

    assert Server.toggle(server) == :on
  end
end
