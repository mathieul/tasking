defmodule Mix.Tasks.StartServer do
  use Mix.Task

  @shortdoc "Start the WsPubsub web server"

  @moduledoc """
  Start the WsPubsub web server
  """
  def run(args) do
    Mix.Task.run "app.start", args
    IO.puts "Started web server."
    unless Code.ensure_loaded?(IEx) && IEx.started? do
      :timer.sleep(:infinity)
    end
  end
end
