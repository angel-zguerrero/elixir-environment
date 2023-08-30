defmodule RkvServer.Subscriber do
  def start_link do
    Phoenix.PubSub.subscribe(MyUmbrella.SharedPubSub, "shared_topic")
  end

  def handle_info({Phoenix.PubSub, _topic, message}, state) do
    IO.puts("RkvServer recibió: #{message}")
    {:noreply, state}
  end
end
