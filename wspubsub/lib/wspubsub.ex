defmodule Wspubsub do
  @doc """
  The application callback used to start this application.
  """
  def start(_type, _args) do
    Wspubsub.Supervisor.start_link(nil)
  end
end
