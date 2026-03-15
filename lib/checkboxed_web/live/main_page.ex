defmodule CheckboxedWeb.MainPage do
  use CheckboxedWeb, :live_view
  alias Phoenix.PubSub
  alias Checkboxed.StateAgent

  @topic "cords"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      PubSub.subscribe(Checkboxed.PubSub, @topic)
    end

    keys = StateAgent.get_all()

    checkboxes =
      for id <- 1..10_000 do
        id_str = Integer.to_string(id)
        %{id: id_str, checked: Map.has_key?(keys, id_str)}
      end

    {:ok,
     socket
     |> stream(:checkboxes, checkboxes, reset: true)}
  end

  @impl true
  def handle_event(
        "change_state",
        %{"id" => id, "value" => "true"} = map,
        socket
      ) do
    StateAgent.set(id, true)
    PubSub.broadcast_from(Checkboxed.PubSub, self(), @topic, {:change, map})

    {:noreply, stream_insert(socket, :checkboxes, %{id: id, checked: true}, at: -1)}
  end

  @impl true
  def handle_event(
        "change_state",
        %{"id" => id},
        socket
      ) do
    StateAgent.delete(id)

    PubSub.broadcast_from(
      Checkboxed.PubSub,
      self(),
      @topic,
      {:change, %{"id" => id, "value" => "false"}}
    )

    {:noreply, stream_insert(socket, :checkboxes, %{id: id, checked: false})}
  end

  @impl true
  def handle_info(
        {:change, %{"id" => id, "value" => "true"}},
        socket
      ) do
    {:noreply, stream_insert(socket, :checkboxes, %{id: id, checked: true})}
  end

  @impl true
  def handle_info(
        {:change, %{"id" => id, "value" => "false"}},
        socket
      ) do
    {:noreply, stream_insert(socket, :checkboxes, %{id: id, checked: false})}
  end
end
