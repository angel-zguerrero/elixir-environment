defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup context do
    #registry = start_supervised!(KV.Registry) # We are using this function due to it call "KV.Registry.start_link" and shutdown the KV.Registry pid before each test
    _ = start_supervised!({KV.Registry, name: context.test})
    %{registry: context.test, test_name: context.test}
  end

  test "spawns buckets", %{registry: registry, test_name: test_name} do
    IO.puts(test_name)
    IO.inspect(registry)
    IO.puts("----------------------")
    assert KV.Registry.lookup(registry, "shopping") == :error

    KV.Registry.create(registry, "shopping")
    assert {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry, test_name: test_name} do
    IO.puts(test_name)
    IO.inspect(registry)
    IO.puts("----------------------")
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)
    _ = KV.Registry.create(registry, "bogus") # horrible workaround to avoid race condition, waiting for handle_info message to be processed
    assert KV.Registry.lookup(registry, "shopping") == :error
  end

  test "removes bucket on crash", %{registry: registry, test_name: test_name} do

    IO.puts(test_name)
    IO.inspect(registry)
    IO.puts("----------------------")
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    # Stop the bucket with non-normal reason
    Agent.stop(bucket, :shutdown)
    _ = KV.Registry.create(registry, "bogus") # horrible workaround to avoid race condition, waiting for handle_info message to be processed
    assert KV.Registry.lookup(registry, "shopping") == :error
  end

  test "are temporary workers" do
    assert Supervisor.child_spec(KV.Bucket, []).restart == :temporary
  end
  test "bucket can crash at any time", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    # Simulate a bucket crash by explicitly and synchronously shutting it down
    Agent.stop(bucket, :shutdown)

    # Now trying to call the dead process causes a :noproc exit
    catch_exit KV.Bucket.put(bucket, "milk", 3)
  end
end
