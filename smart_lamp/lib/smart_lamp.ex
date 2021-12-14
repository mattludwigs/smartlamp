defmodule SmartLamp do
  @moduledoc """
  Main API for interacting with the SmartLamp
  """

  alias SmartLamp.Server

  @typedoc """
  The value of the LED
  """
  @type lamp_value() :: :on | :off

  @typedoc """
  Configuration for a lamp

  A lamp is made up of a button and an LED and a module that implements the
  `SmartLamp.Lamp` behaviour to control the button and LED.
  """
  @type lamp_config() :: %{
          name: lamp_name(),
          button: non_neg_integer(),
          led: non_neg_integer(),
          type: module(),
          button_handler: (() -> :ok)
        }

  @type lamp_name() :: atom()

  @typedoc """
  Options for the SmartLamp library

  * `:lamps` - a list of lamp configurations
  """
  @type opt() :: {:lamps, [lamp_config()]} | {:pub_sub, module()}

  @doc """
  Get all lamp names
  """
  @spec lamps() :: [SmartLamp.lamp_name()]
  def lamps() do
    children = Supervisor.which_children(SmartLamp.Supervisor)

    Enum.map(children, fn {_module, pid, :worker, _} ->
      pid
      |> Server.info()
      |> Map.get(:name)
    end)
  end

  @doc """
  Toggle the state of LED (on or off)

  This will return the new lamp value.
  """
  @spec toggle(lamp_name()) :: lamp_value()
  def toggle(name) do
    Server.toggle(name)
  end

  @doc """
  Get the current value from the lamp
  """
  def get_value(name) do
    Server.get_value(name)
  end
end
