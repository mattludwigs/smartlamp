defmodule SmartLampFw.Lamp do
  @moduledoc """
  Custom hardware implementation for the `SmartLamp.Lamp` behaviour
  """

  @behaviour SmartLamp.Lamp

  alias Circuits.GPIO

  @led_gpio 17
  @button_gpio 27

  @impl SmartLamp.Lamp
  def init(_) do
    {:ok, led} = GPIO.open(@led_gpio, :output)
    {:ok, button} = GPIO.open(@button_gpio, :input)

    :ok = GPIO.set_interrupts(button, :falling)

    {:ok, %{led: led, button: button, last_value: :off}}
  end

  @impl SmartLamp.Lamp
  def toggle(%{last_value: :off} = state) do
    :ok = GPIO.write(state.led, 1)
    %{state | last_value: :on}
  end

  def toggle(%{last_value: :on} = state) do
    :ok = GPIO.write(state.led, 0)
    %{state | last_value: :off}
  end

  @impl SmartLamp.Lamp
  def get_value(state) do
    case GPIO.read(state.led) do
      1 -> :on
      0 -> :off
    end
  end

  @impl SmartLamp.Lamp
  def handle_info({:circuits_gpio, @button_gpio, _ts, 0}, state, handler) do
    :ok = handler.()
    toggle(state)
  end

  def handle_info(other, state) do
    state
  end
end
