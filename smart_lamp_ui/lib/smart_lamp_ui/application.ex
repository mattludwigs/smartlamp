defmodule SmartLampUi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SmartLampUiWeb.Telemetry,
      {SmartLamp.Supervisor, lamps: get_lamps_def()},
      # Start the PubSub system
      {Phoenix.PubSub, name: SmartLampUi.PubSub},
      # Start the Endpoint (http/https)
      SmartLampUiWeb.Endpoint
      # Start a worker by calling: SmartLampUi.Worker.start_link(arg)
      # {SmartLampUi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SmartLampUi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SmartLampUiWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp get_lamps_def() do
    case Application.get_env(:smart_lamp, :lamps) do
      nil -> []
      # in a real project I would think this through more
      lamps -> with_ui_handler(lamps)
    end
  end

  defp with_ui_handler(lamps) do
    Enum.map(lamps, fn lamp ->
      Map.put(lamp, :button_handler, &SmartLampUi.broadcast_button_event/0)
    end)
  end
end
