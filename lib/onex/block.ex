defmodule Onex.Block do
  alias Onex.ProofOfWork

  defstruct timestamp: :os.system_time(:millisecond),
            data: "",
            prev_block_hash: "",
            hash: "",
            nonce: 0

  @spec new(String.t(), String.t()) :: Block
  def new(data, prev_block_hash) do
    block = %Onex.Block{
      data: data,
      prev_block_hash: prev_block_hash
    }

    timestamp = block.timestamp
    headers = :crypto.hash(:sha256, data <> prev_block_hash <> to_string(timestamp))

    block = %Onex.Block{block | hash: headers}
    {nonce, hash} = block |> ProofOfWork.new() |> ProofOfWork.run()
    %Onex.Block{block | hash: hash, nonce: nonce}
  end

  @spec genesis() :: Block
  def genesis do
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
