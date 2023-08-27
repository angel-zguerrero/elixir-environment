defmodule RkvServer.TcpServer do
  require Logger
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
    [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"
    accept_connection(socket)
  end

  def accept_connection(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Task.start_link(fn -> serve(client) end)
    accept_connection(socket)
  end

  defp serve(socket) do
    {:ok, msg} = read_line(socket)
    IO.inspect(msg)
    write_line(socket, msg)
    serve(socket)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp write_line(socket, msg) do
    :gen_tcp.send(socket, msg)
  end
end
