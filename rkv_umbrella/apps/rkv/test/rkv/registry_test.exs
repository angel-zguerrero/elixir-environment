defmodule Rkv.RegistryTest do
  use ExUnit.Case, async: false

  setup context do
    _ = start_supervised!({Rkv.Registry, [name: context.test]})
    %{registry: context.test}
  end

  test "test spawn buckets", %{registry: registry} do
    test_bucket_name = "test_bucket"
    test_bucket_key = "test_key"
    test_bucket_value = "test_bucket_value"

    assert :error == Rkv.Registry.lookup(registry, test_bucket_name)
    assert :ok == Rkv.Registry.create(registry, test_bucket_name)
    assert {:ok, bucket} = Rkv.Registry.lookup(registry, test_bucket_name)
    assert nil == Rkv.Bucket.get(bucket, test_bucket_key)
    assert :ok == Rkv.Bucket.put(bucket, test_bucket_key, test_bucket_value)
    assert test_bucket_value == Rkv.Bucket.get(bucket, test_bucket_key)
  end

  test "test remove bucket on stop it", %{registry: registry} do
    test_bucket_name = "test_bucket"

    assert :ok == Rkv.Registry.create(registry, test_bucket_name)
    assert {:ok, bucket} = Rkv.Registry.lookup(registry, test_bucket_name)
    Agent.stop(bucket)
    assert :error == Rkv.Registry.lookup(registry, test_bucket_name)
  end

  test "test remove bucket on agent crash", %{registry: registry} do
    test_bucket_name = "test_bucket"
    assert :ok == Rkv.Registry.create(registry, test_bucket_name)
    assert {:ok, bucket} = Rkv.Registry.lookup(registry, test_bucket_name)
    Agent.stop(bucket, :shutdown)
    assert :error == Rkv.Registry.lookup(registry, test_bucket_name)
  end
end
