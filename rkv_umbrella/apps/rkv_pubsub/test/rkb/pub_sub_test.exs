defmodule Rkb.PubSubTest do
  use ExUnit.Case
  doctest Rkb.PubSub

  test "greets the world" do
    assert Rkb.PubSub.hello() == :world
  end
end
