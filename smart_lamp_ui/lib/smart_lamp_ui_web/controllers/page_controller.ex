defmodule SmartLampUiWeb.PageController do
  use SmartLampUiWeb, :controller

  def index(conn, _params) do
    lamps = SmartLamp.lamps()
    render(conn, "index.html", lamps: lamps)
  end
end
