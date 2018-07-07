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

  @spec run(ProofOfWork) :: {number, String.t}
  def run(pow) do
    run_until(pow, 0)
  end

  @spec run_until(ProofOfWork, number) :: {number, String.t}
  defp run_until(pow, nonce) do
    data = prepare(pow, nonce)
    new_hash = :crypto.hash(:sha256, data)
    hash_num = new_hash |> :binary.decode_unsigned
    if hash_num < pow.target do
      {nonce, new_hash}
    else
      run_until(pow, nonce + 1)
    end
  end

  @spec prepare(ProofOfWork, number) :: String.t
  defp prepare(pow, nonce) do
    block = pow.block
    block.prev_block_hash <> block.data <>
    to_string(block.timestamp) <> to_string(@target_bits) <> to_string(nonce)
  end
end
