defmodule RkvServerTest do
  use ExUnit.Case
  doctest RkvServer

  test "greets the world" do
    assert RkvServer.hello() == :world
  end
end
