defmodule KVTest do
  use ExUnit.Case
  doctest KV

  exclude =
    if Node.alive?(), do: [], else: [distributed: true]

  ExUnit.start(exclude: exclude)
end
