defmodule Rkv.Bucket do
  use Agent, restart: :temporary

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  def put(agent, key, value) do
    Agent.update(agent, fn map -> Map.put(map, key, value) end)
  end

  def get(agent, key) do
    Agent.get(agent, fn map -> Map.get(map, key) end)
  end

  def delete(agent, key) do
    Agent.get_and_update(agent, fn map -> Map.pop(map, key) end)
  end
end
