defmodule Onex.Blockchain do
  alias Onex.{Block, Storage}

  defstruct tip: ""

  @spec new() :: Blockchain
  def new() do
    tip =
      case Storage.empty?(Storage) do
        true ->
          block = Block.genesis()
          Storage.put_block(Storage, block)
          block.hash

        false ->
          Storage.get_last_hash(Storage)
      end

    %Onex.Blockchain{tip: tip}
  end

  @spec add(String.t()) :: Blockchain
  def add(data) do
    last_hash = Storage.get_last_hash(Storage)
    new_block = Block.new(data, last_hash)
    Storage.put_block(Storage, new_block)
    %Onex.Blockchain{tip: new_block.hash}
  end
end
