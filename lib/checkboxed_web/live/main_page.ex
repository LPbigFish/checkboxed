defmodule CheckboxedWeb.MainPage do
  use CheckboxedWeb, :live_view

  @topic "cords"

  def render(assigns) do
    ~H"""
      <.input type="checkbox" checked={true} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do

    if connected?(socket) do
      Phoenix.PubSub.subscribe(Checkboxed.PubSub, @topic)
    end

    {:ok, socket}
  end

  def handle_event(_event, _unsigned_params, socket) do
    {:noreply, socket}
  end
end
