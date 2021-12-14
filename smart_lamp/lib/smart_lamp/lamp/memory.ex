defmodule SmartLamp.Lamp.Memory do
  @moduledoc """
  An in memory `SmartLamp.Lamp` implementation

  This is useful for testing and local development as it does not
  talk to any hardware.
  """

  @behaviour SmartLamp.Lamp

  @impl SmartLamp.Lamp
  def init(initial_value) do
    {:ok, initial_value}
  end

  @impl SmartLamp.Lamp
  def toggle(:off) do
    :on
  end

  def toggle(:on) do
    :off
  end

  @impl SmartLamp.Lamp
  def get_value(state) do
    state
  end

  @impl SmartLamp.Lamp
  def handle_info(_message, state, handler) do
    :ok = handler.()
    state
  end
end
