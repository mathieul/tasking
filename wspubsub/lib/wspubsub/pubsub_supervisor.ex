defmodule Wspubsub.PubsubSupervisor do
  use Supervisor.Behaviour

  #####
  # External API

  def start_link(_) do
    :supervisor.start_link(__MODULE__, nil)
  end

  #####
  # Supervisor implementation

  def init(_) do
    child_processes = [ worker(Wspubsub.Pubsub, [ nil ]) ]
    supervise(child_processes, strategy: :one_for_one)
  end
end
