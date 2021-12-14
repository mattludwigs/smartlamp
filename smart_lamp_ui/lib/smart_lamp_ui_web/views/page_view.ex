defmodule SmartLampUiWeb.PageView do
  use SmartLampUiWeb, :view

  def display_name(lamp_name) when is_atom(lamp_name) do
    Atom.to_string(lamp_name)
  end

  def display_name(lamp_name), do: lamp_name
end
