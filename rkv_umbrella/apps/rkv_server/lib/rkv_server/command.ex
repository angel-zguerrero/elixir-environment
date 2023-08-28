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
    {:ok, "#{bucket} CREATED\r\n"}
  end
  def execute({:delete, bucket}) do
    {:ok, "#{bucket} DELETED\r\n"}
  end
  def execute({:lookup, bucket}) do
    {:ok, "Bucket: #{bucket}\r\n"}
  end

  def execute({:error, :unknown_command}) do
    {:error, :unknown_command}
  end
end
