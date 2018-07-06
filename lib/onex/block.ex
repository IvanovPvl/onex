defmodule Onex.Block do
  defstruct timestamp: :os.system_time(:millisecond), data: "", prev_block_hash: "", hash: ""

  def new(data, prev_block_hash) do
    block = %Onex.Block{
      data: data,
      prev_block_hash: prev_block_hash
    }

    timestamp = block.timestamp
    headers = :crypto.hash(:sha256, data <> prev_block_hash <> Integer.to_string(timestamp))

    %Onex.Block{block | hash: headers}
  end

  def genesis() do
    new("Genesis block", "")
  end
end

defimpl Inspect, for: Onex.Block do
  def inspect(block, _) do
    hash_str = block.hash |> Base.encode16() |> String.downcase()
    prev_block_hash_str = block.prev_block_hash |> Base.encode16() |> String.downcase()

    """
    timestamp: #{block.timestamp}
    data: #{block.data}
    prev_block_hash: #{prev_block_hash_str}
    hash: #{hash_str}
    """
  end
end
