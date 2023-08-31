defmodule RkvServer.Router do

  def route(bucket) do
    first = :binary.first(bucket)
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
    IO.inspect("remote node")
    IO.inspect(remote_node)
  end
end
