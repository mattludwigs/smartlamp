defmodule SmartLamp.Lamp do
  @moduledoc """
  Behavior for defining how to work with the SmartLamp
  """

  @typedoc """
  The state of the driver
  """
  @type state() :: any()

  @doc """
  Initialize the Driver
  """
  @callback init(SmartLamp.lamp_value()) :: {:ok, state()}

  @doc """
  Toggle the state of the LED
  """
  @callback toggle(state()) :: state()

  @doc """
  Get the value of the LED
  """
  @callback get_value(state()) :: SmartLamp.lamp_value()

  @doc """
  Handle messages that come to the lamp
  """
  @callback handle_info(message :: any(), state(), button_handler :: (() -> :ok)) :: state()
end
