defmodule Onex.ProofOfWork do
  use Bitwise
  alias Onex.Block

  @target_bits 22

  defstruct block: nil, target: 0

  @spec new(Block) :: ProofOfWork
  def new(block) do
    %Onex.ProofOfWork{
      block: block,
      target: 1 <<< (256 - @target_bits)
    }
  end

  @spec run(ProofOfWork) :: {number, String.t()}
  def run(pow) do
    run_until(pow, 0)
  end

  @spec validate(ProofOfWork) :: boolean
  def validate(pow) do
    data = prepare(pow, pow.block.nonce)
    {hash_num, _} = hash_and_num(data)
    hash_num < pow.target
  end

  @spec run_until(ProofOfWork, number) :: {number, String.t()}
  defp run_until(pow, nonce) do
    data = prepare(pow, nonce)
    {hash_num, new_hash} = hash_and_num(data)

    if hash_num < pow.target do
      {nonce, new_hash}
    else
      run_until(pow, nonce + 1)
    end
  end

  @spec prepare(ProofOfWork, number) :: String.t()
  defp prepare(pow, nonce) do
    block = pow.block

    block.prev_block_hash <>
      block.data <> to_string(block.timestamp) <> to_string(@target_bits) <> to_string(nonce)
  end

  @spec hash_and_num(String.t()) :: {number, String.t()}
  defp hash_and_num(data) do
    hash = :crypto.hash(:sha256, data)
    hash_num = hash |> :binary.decode_unsigned()
    {hash_num, hash}
  end
end
