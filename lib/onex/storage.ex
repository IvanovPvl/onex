defmodule Onex.Storage do
  use Agent

  def start_link(opts) do
    Agent.start_link(fn -> %{} end, opts)
  end

  @spec get_block(Agent.agent(), String.t()) :: Onex.Block
  def get_block(storage, hash) do
    Agent.get(storage, &Map.get(&1, hash))
  end

  @spec put_block(Agent.agent(), Onex.Block) :: :ok
  def put_block(storage, block) do
    Agent.update(storage, &Map.put(&1, block.hash, block))
    Agent.update(storage, &Map.put(&1, "last", block.hash))
  end

  @spec get_last_hash(Agent.agent()) :: String.t()
  def get_last_hash(storage) do
    Agent.get(storage, &Map.get(&1, "last"))
  end

  @spec get_last_block(Agent.agent()) :: String.t()
  def get_last_block(storage) do
    last_hash = Onex.Storage.get_last_hash(storage)
    Onex.Storage.get_block(storage, last_hash)
  end

  @spec empty?(Agent.agent()) :: boolean
  def empty?(storage) do
    Onex.Storage.get_last_hash(storage) == nil
  end
end
