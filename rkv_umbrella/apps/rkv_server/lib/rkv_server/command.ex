defmodule RkvServer.Command do
  def parse(command) do
    case String.split(command) do
      ["CREATE", "BUCKET", bucket] -> {:create, bucket}
      ["DELETE", "BUCKET", bucket] -> {:delete, bucket}
      ["LOOKUP", "BUCKET", bucket] -> {:lookup, bucket}
      ["GET", bucket, key] -> {:get, bucket, key}
      ["PUT", bucket, key, value] -> {:put, bucket, key, value}
      ["DEL", bucket, key] -> {:del, bucket, key}

      _ -> {:error, :unknown_command}
    end
  end
  def run(command) do
    execute(parse(command))
  end
  def execute({:create, bucket}) do
    #Rkv.Registry.create(Rkv.Registry, bucket)
    RkvServer.Router.route(bucket)
    {:ok, "OK\r\n"}
  end
  def execute({:delete, bucket}) do
    Rkv.Registry.delete(Rkv.Registry, bucket)
    {:ok, "OK\r\n"}
  end
  def execute({:lookup, bucket}) do
    lookupBucket(bucket, fn (bucketPid) ->
      {:ok, "#{inspect(bucketPid)}\r\n"}
    end)
  end

  def execute({:get, bucket, key}) do
    lookupBucket(bucket, fn (bucketPid) ->
      value = Rkv.Bucket.get(bucketPid, key)
      {:ok, "#{value}\r\n"}
    end)
  end

  def execute({:put, bucket, key, value}) do
    lookupBucket(bucket, fn (bucketPid) ->
      Rkv.Bucket.put(bucketPid, key, value)
      {:ok, "OK\r\n"}
    end)
  end

  def execute({:del, bucket, key}) do
    lookupBucket(bucket, fn (bucketPid) ->
      Rkv.Bucket.delete(bucketPid, key)
      {:ok, "OK\r\n"}
    end)
  end

  def execute({:error, :unknown_command}) do
    {:error, :unknown_command}
  end

  def execute(_mmsg) do
    {:error, :unknown_command}
  end
  def lookupBucket(bucket, callback) do

    with {:ok, pid} <- Rkv.Registry.lookup(Rkv.Registry, bucket) do
      callback.(pid)
    else
      _ -> {:ok, "Bucket not found\r\n"}
    end
  end
end
