defmodule Wspubsub.Supervisor do
  use Supervisor.Behaviour

  #####
  # External API

  def start_link(_) do
    :supervisor.start_link(__MODULE__, nil)
  end

  #####
  # Supervisor implementation

  def init(_) do
    child_processes = [
      supervisor(Wspubsub.PubsubSupervisor, [ nil ])
    ]
    supervise(child_processes, strategy: :one_for_one)
  end
end
