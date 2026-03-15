defmodule Checkboxed.StateAgent do
  use Agent

  def start_link(_opts \\ []) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get_all do
    Agent.get(__MODULE__, & &1)
  end

  def set(id, value) do
    Agent.update(__MODULE__, &Map.put(&1, id, value))
  end

  def delete(id) do
    Agent.update(__MODULE__, &Map.delete(&1, id))
  end
end
