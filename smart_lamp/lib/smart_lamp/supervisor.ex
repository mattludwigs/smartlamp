defmodule SmartLamp.Supervisor do
  @moduledoc """
  Supervisor for the SmartLamp library

  To configure a lamp using the in memory driver:

  ```elixir
  SmartLamp.Supervisor.start_link(lamps: %{name: :lamp1})
  ```

  """

  use Supervisor

  require Logger

  alias SmartLamp.Server
  alias SmartLamp.Lamp.Memory

  @doc """
  Start the supervisor
  """
  @spec start_link([SmartLamp.opt()]) :: Supervisor.on_start()
  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl Supervisor
  def init(args) do
    Supervisor.init(children(args), strategy: :one_for_one)
  end

  def children(args) do
    build_children([], args)
  end

  defp build_children(children, []) do
    children
  end

  defp build_children(children, [{:lamps, lamps} | args]) do
    new_children =
      Enum.reduce(lamps, children, fn lamp, c ->
        c ++
          [
            {Server,
             name: lamp.name, type: lamp[:type] || Memory, button_handler: get_button_handle(lamp)}
          ]
      end)

    build_children(new_children, args)
  end

  defp get_button_handle(%{button_handler: handler}), do: handler

  defp get_button_handle(lamp) do
    fn ->
      Logger.info("""
      Lamp: #{inspect(lamp.name)}
      Event: Button pressed
      """)
    end
  end
end
