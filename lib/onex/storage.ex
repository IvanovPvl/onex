defmodule Onex.Storage do
  use Agent

  def start_link(opts) do
    Agent.start_link(fn -> %{} end, opts)
  end

  @spec get_block(Agent.agent(), String.t()) :: Onex.Block
  def get_block(storage, hash) do
    Agent.get(storage, &Map.get(&1, hash))
  end

  @spec get_last_block(Agent.agent()) :: Onex.Block
  def get_last_block(storage) do
    get_block(storage, "last")
  end

  @spec put_block(Agent.agent(), String.t(), Onex.Block) :: :ok
  def put_block(storage, hash, block) do
    Agent.update(storage, &Map.put(&1, hash, block))
  end
end
