defmodule Rkv.Registry do
  use GenServer

  def start_link(opts) do
    Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    bucket_dictionary = %{}
    bucket_references_dictionary = %{}
    {:ok, {bucket_dictionary, bucket_references_dictionary}}
  end

  def create(registryPid, name) do
    GenServer.call(registryPid, {:create, name})
  end

  def delete(registryPid, name) do
    GenServer.call(registryPid, {:delete, name})
  end

  def lookup(registryPid, name) do
    GenServer.call(registryPid, {:lookup, name})
  end

  def handle_call({:lookup, name}, _from, state) do
    # we want to return :error istead of :nil, when the key does not exist
    {bucket_dictionary, _} = state
    bucket = Map.fetch(bucket_dictionary, name)
    {:reply, bucket, state}
  end

  def handle_call({:create, name}, _from, {bucket_dictionary, bucket_references_dictionary}) do
    if Map.has_key?(bucket_dictionary, name) do
      {:reply, :ok, {bucket_dictionary, bucket_references_dictionary}}
    else
      {:ok, bucket} = DynamicSupervisor.start_child(KV.BucketSupervisor, Rkv.Bucket.child_spec(:ok))
      bucketRef = Process.monitor(bucket)
      bucket_dictionary = Map.put(bucket_dictionary, name, bucket)
      bucket_references_dictionary = Map.put(bucket_references_dictionary, bucketRef, name)
      {:reply, :ok, {bucket_dictionary, bucket_references_dictionary}}
    end
  end

  def handle_call({:delete, name}, _from, {bucket_dictionary, bucket_references_dictionary}) do
    if Map.has_key?(bucket_dictionary, name) do
      {bucket, bucket_dictionary} = Map.pop(bucket_dictionary, name)
      Agent.stop(bucket)
      {:reply, bucket, {bucket_dictionary, bucket_references_dictionary}}
    else
      {:reply, :ok, {bucket_dictionary, bucket_references_dictionary}}
    end
  end
  def handle_info({:DOWN, bucketRef, :process, _bucket, _reason}, {bucket_dictionary, bucket_references_dictionary}) do
    {:ok, bucket_name} =  Map.fetch(bucket_references_dictionary, bucketRef)
    {_bucket, bucket_dictionary} = Map.pop(bucket_dictionary, bucket_name)
    {_ref, bucket_references_dictionary} = Map.pop(bucket_references_dictionary, bucketRef)
    {:noreply, {bucket_dictionary, bucket_references_dictionary}}
  end

  def terminate(_reason, _state) do
    buckets = DynamicSupervisor.which_children(KV.BucketSupervisor)
    Enum.map(buckets, fn {_, bucket, _, _} ->
      IO.inspect(bucket)
      IO.inspect(Agent.stop(bucket))
    end)
    :ok
  end
end
