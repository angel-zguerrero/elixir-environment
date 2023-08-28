defmodule RkvServer.WorkerRegistryListener do
  use GenServer
  alias Phoenix.PubSub


  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(_init_arg) do
    PubSub.subscribe(Rkv.Server.PubSub, "worker:registry:listener")
    {:ok, []}
  end
  def handle_info(msg, state) do
    require Logger
    Logger.debug("update route table here!!: #{inspect(msg)}")
    {:noreply, state}
  end
end
