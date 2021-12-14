defmodule SmartLampUiWeb.LampLive do
  use SmartLampUiWeb, :live_view

  @impl true
  def render(assigns) do
    ~L"""
    <h1><%= @name %></h1>

    <p><%= @value %></p>

    <button phx-click="turn_on">ON</button>
    <button phx-click="turn_off">OFF</button>
    """
  end

  @impl true
  def mount(%{"name" => lamp_name}, _session, socket) do
    if connected?(socket), do: SmartLampUi.subscribe_button_event()

    {:ok,
     socket |> assign(:name, lamp_name) |> assign(:value, SmartLampUi.get_lamp_value(lamp_name))}
  end

  @impl true
  def handle_event("turn_on", _value, socket) do
    case socket.assigns[:value] do
      :on ->
        {:noreply, socket}

      :off ->
        do_toggle(socket)
    end
  end

  def handle_event("turn_off", _value, socket) do
    case socket.assigns[:value] do
      :off ->
        {:noreply, socket}

      :on ->
        do_toggle(socket)
    end
  end

  defp do_toggle(socket) do
    new_value = SmartLampUi.toggle!(socket.assigns[:name])
    {:noreply, socket |> assign(:value, new_value)}
  end

  @impl true
  def handle_info(:button_pressed, socket) do
    {:noreply, assign(socket, :value, SmartLampUi.get_lamp_value(socket.assigns[:name]))}
  end
end
