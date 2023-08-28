defmodule CommandTest do
  use ExUnit.Case
  test "create bucket" do
    assert {:create, _bucket} = RkvServer.Command.parse("CREATE BUCKET my_bucket")
  end
  test "lookup bucket" do
    assert {:lookup, _bucket} = RkvServer.Command.parse("LOOKUP BUCKET my_bucket")
  end
  test "delete bucket" do
    assert {:delete, _bucket} = RkvServer.Command.parse("DELETE BUCKET my_bucket")
  end

  test "get value from key" do
    assert {:get, _bucket, _key} = RkvServer.Command.parse("GET my_bucket key")
  end

  test "put value in key" do
    assert {:put, _bucket, _key, _value} = RkvServer.Command.parse("PUT my_bucket key value")
  end

  test "delete value in key" do
    assert {:del, _bucket, _key} = RkvServer.Command.parse("DEL my_bucket key")
  end
end
