defmodule KV.Bucket do
  use Agent, restart: :temporary

  @doc """
  Starts a new bucket.
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Gets a value from the `bucket` by `key`.
  """
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in the `bucket`.
  """
  def put(bucket, key, value) do
    IO.puts("Calling Agent update")
    IO.inspect(self())
   result = Agent.update(bucket, fn map ->
        IO.puts("updating map")
        IO.inspect(self())
        map = Map.put(map, key, value)
        IO.puts("updated map")
        map
    end)
    IO.puts("Called Agent update")
    IO.inspect(self())
    IO.puts("All the above code was executed synchronously")
    result
  end

  def delete(bucket, key) do
    Agent.get_and_update(bucket, fn dict ->
      Map.pop(dict, key)
    end)
  end
end
