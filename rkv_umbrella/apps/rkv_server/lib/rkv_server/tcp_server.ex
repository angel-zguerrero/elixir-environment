defmodule RkvServer.TcpServer do
  require Logger
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
    [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"

    {:ok, client} = :gen_tcp.accept(socket)

  end
end
