defmodule Onex do
  use Application

  def start(_type, _args) do
    Onex.Supervisor.start_link(name: Onex.Supervisor)
  end
end
