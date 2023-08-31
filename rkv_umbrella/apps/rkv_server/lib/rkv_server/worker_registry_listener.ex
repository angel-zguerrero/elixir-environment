defmodule RkvServer.WorkerRegistryListener do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_init_arg) do
    Phoenix.PubSub.subscribe(Rkb.PubSub.Service, "worker:registry:listener")
    {:ok, %{}}
  end

  def handle_info(remote_node_info, state) do
    require Logger
    routing_table = Application.fetch_env!(:rkv_server, :routing_table)
    #Logger.debug("routing_table : #{inspect(routing_table)}")
    time_life = 60
    current_time = DateTime.utc_now()
    ttl = DateTime.add(current_time, time_life, :second)
    routing_table = Map.put(routing_table, remote_node_info[:node], ttl)
    keys_to_remove =
      Enum.filter(Map.keys(routing_table), fn remote_node ->
        node_ttl = routing_table[remote_node]
        time_diff = DateTime.diff(node_ttl, current_time, :second)
        time_diff <= 0
      end)

    Application.put_env(:rkv_server, :routing_table, Map.drop(routing_table, keys_to_remove))
    {:noreply, state}
  end
end
