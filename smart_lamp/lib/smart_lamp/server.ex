defmodule SmartLamp.Server do
  @moduledoc false

  # Server for handling interactions with the LED

  use GenServer

  alias SmartLamp.Lamp.Memory

  @typedoc """
  """
  @type arg() ::
          {:name, SmartLamp.lamp_name()}
          | {:type, module()}
          | {:initial_value, SmartLamp.lamp_value()}
          | {:button_handler, (() -> :ok)}

  @typedoc """
  Information about a lamp
  """
  @type lamp_info() :: %{
          name: SmartLamp.lamp_name(),
          type: module(),
          current_value: SmartLamp.lamp_value()
        }

  @doc """
  Start the SmartLamp server
  """
  @spec start_link([arg()]) :: GenServer.on_start()
  def start_link(args) do
    name = args[:name] || raise ArgumentError, "A lamp is required to have a name"
    GenServer.start_link(__MODULE__, args, name: name)
  end

  @doc """
  Toggle the state of the LED

  This will return the new value of the lamp.
  """
  @spec toggle(SmartLamp.lamp_name() | pid()) :: SmartLamp.lamp_value()
  def toggle(name) do
    GenServer.call(name, :toggle)
  end

  @doc """
  Get information about lamp
  """
  @spec info(SmartLamp.lamp_name() | pid()) :: lamp_info()
  def info(server) do
    GenServer.call(server, :info)
  end

  @doc """
  Get the current value of the LED
  """
  @spec get_value(SmartLamp.lamp_name() | pid()) :: SmartLamp.lamp_value()
  def get_value(name) do
    GenServer.call(name, :get_value)
  end

  @impl GenServer
  def init(args) do
    impl = args[:type] || Memory
    initial_value = args[:init_value] || :off

    case impl.init(initial_value) do
      {:ok, impl_state} ->
        {:ok,
         %{
           impl: impl,
           impl_state: impl_state,
           name: args[:name],
           button_handler: args[:button_handler]
         }}

      error ->
        {:stop, error}
    end
  end

  @impl GenServer
  def handle_call(:toggle, _from, state) do
    new_impl_state = state.impl.toggle(state.impl_state)
    current_value = state.impl.get_value(new_impl_state)

    {:reply, current_value, %{state | impl_state: new_impl_state}}
  end

  def handle_call(:get_value, _from, state) do
    value = state.impl.get_value(state.impl_state)

    {:reply, value, state}
  end

  def handle_call(:info, _from, state) do
    info = %{
      name: state.name,
      type: state.impl,
      current_value: state.impl.get_value(state.impl_state)
    }

    {:reply, info, state}
  end

  @impl GenServer
  def handle_info(message, state) do
    new_impl_state = state.impl.handle_info(message, state.impl_state, state.button_handler)
    {:noreply, %{state | impl_state: new_impl_state}}
  end
end
