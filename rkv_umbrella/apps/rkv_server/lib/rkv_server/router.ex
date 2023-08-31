defmodule RkvServer.Router do

  def route(bucket, module, func, args) do
    first = :binary.first(String.downcase(bucket))
    routing_table = Application.fetch_env!(:rkv_server, :routing_table)
    remote_nodes =  Map.keys(routing_table)
    remote_nodes = remote_nodes
    |>Enum.filter(fn remote_node -> length(remote_nodes) == 1 || node() != remote_node end)
    |>Enum.sort()

    range_index = Range.split(?a..?z, length(remote_nodes))
    |> Tuple.to_list()
    |> Enum.find_index(fn element ->
      first in element
    end)
    remote_node = Enum.at(remote_nodes, range_index)
    if(remote_node == node()) do
      apply(module, func, args)
    else
      {Rkv.TaskRemoteCaller, remote_node}
      |>Task.Supervisor.async(module, func, args)
      |>Task.await()
    end
  end
end


#Node.spawn_link(:"client0_rkv@8e6012416857", fn -> IO.inspect(node())  end)

#Node.spawn_link(:"client0_rkv@8e6012416857", fn -> Rkv.Registry.create(Rkv.Registry, "bucket_")  end)
#Task.Supervisor.async({Rkv.TaskRemoteCaller, :"client0_rkv@8e6012416857"}, Rkv.Registry, :create, [Rkv.Registry, "bucket_1"])
#task = Task.Supervisor.async({Rkv.TaskRemoteCaller, :"client0_rkv@8e6012416857"}, fn -> {:ok, node()} end)
#task = Task.Supervisor.async({Rkv.TaskRemoteCaller, :server_rkv@8e6012416857}, fn -> {:ok, node()} end)
#Task.await(task)
