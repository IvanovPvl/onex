defmodule Onex.Blockchain do
  alias Onex.Block

  defstruct blocks: []

  @spec new() :: Blockchain
  def new() do
    %Onex.Blockchain{blocks: [Block.genesis()]}
  end

  @spec add(Blockchain, String.t) :: Blockchain
  def add(blockchain, data) do
    new_block = Block.new(data, hd(blockchain.blocks).hash)
    %Onex.Blockchain{blocks: [new_block | blockchain.blocks]}
  end
end
