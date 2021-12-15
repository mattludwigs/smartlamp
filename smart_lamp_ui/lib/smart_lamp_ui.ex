defmodule SmartLampUi do
  @moduledoc """
  """

  def get_lamp_value(name) do
    case parse_name(name) do
      nil ->
        nil

      parsed ->
        SmartLamp.get_value(parsed)
    end
  end

  defp parse_name(name) when is_binary(name) do
    try do
      String.to_existing_atom(name)
    rescue
      ArgumentError ->
        nil
    end
  end

  defp parse_name(name) when is_atom(name), do: name

  def toggle!(name) do
    case parse_name(name) do
      nil ->
        raise ArgumentError, "Cannot toggle unknown lamp"

      parsed ->
        SmartLamp.toggle(parsed)
        broadcast_button_event()
    end
  end

  def subscribe_button_event() do
    Phoenix.PubSub.subscribe(SmartLampUi.PubSub, "button_event")
  end

  def broadcast_button_event() do
    Phoenix.PubSub.broadcast(SmartLampUi.PubSub, "button_event", :button_pressed)
  end
end
