defmodule Onex do
  alias Onex.Blockchain

  def run do
    blockchain =
      Blockchain.new
      |> Blockchain.add("Send 1 BTC to Pavel")
      |> Blockchain.add("Send 2 BTC to Ivan")

    IO.inspect blockchain
  end
end
