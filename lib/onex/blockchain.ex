defmodule Onex.Blockchain do
  alias Onex.Block

  defstruct blocks: []

  def new() do
    %Onex.Blockchain{blocks: [Block.genesis()]}
  end

  def add(blockchain, data) do
    new_block = Block.new(data, List.first(blockchain.blocks).hash)
    %Onex.Blockchain{blocks: [new_block | blockchain.blocks]}
  end
end
