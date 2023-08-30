defmodule RkvServer.WorkerRegistryListener do
  use GenServer


  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(_init_arg) do
    Phoenix.PubSub.subscribe(Rkb.PubSub.Service, "worker:registry:listener")
    IO.puts("*******************")
    IO.inspect(self())
    IO.puts("################")


    {:ok, []}
  end
  def handle_info(msg, state) do
    require Logger
    IO.inspect(msg)
    Logger.debug("update route table here!!: #{inspect(msg)}")
    {:noreply, state}
  end
end
