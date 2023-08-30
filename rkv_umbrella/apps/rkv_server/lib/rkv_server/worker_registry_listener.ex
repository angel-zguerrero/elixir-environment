defmodule RkvServer.WorkerRegistryListener do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_init_arg) do
    Phoenix.PubSub.subscribe(Rkb.PubSub.Service, "worker:registry:listener")
    {:ok, %{}}
  end

  def handle_info(remote_node_info, route_table) do
    require Logger
    Logger.debug("route_table : #{inspect(route_table)}")
    time_life = 60
    current_time = DateTime.utc_now()
    ttl = DateTime.add(current_time, time_life, :second)
    route_table = Map.put(route_table, remote_node_info[:node], ttl)
    keys_to_remove =
      Enum.filter(Map.keys(route_table), fn remote_node ->
        node_ttl = route_table[remote_node]
        time_diff = DateTime.diff(node_ttl, current_time, :second)
        time_diff <= 0
      end)
    {:noreply, Map.drop(route_table, keys_to_remove)}
  end
end
