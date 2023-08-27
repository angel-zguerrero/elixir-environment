defmodule Rkv.BucketTest do
  use ExUnit.Case, async: true

  setup context do
    {:ok, bucket} = Rkv.Bucket.start_link(context.test)
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert Rkv.Bucket.get(bucket, "test") == :nil
    Rkv.Bucket.put(bucket, "test", "test_value")
    value = Rkv.Bucket.get(bucket, "test")
    assert value == "test_value"
  end
end
