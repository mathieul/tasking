defmodule Teller.Cowboy.WebsocketTester do
  @behaviour :websocket_client_handler

  #
  # Public API
  #
  # i.e.:
  # > pid = Teller.Cowboy.WebsocketTester.start_link('ws://echo.websocket.org')
  # > Teller.Cowboy.WebsocketTester.send_text(pid, "il etait un petit navire...")
  # > Teller.Cowboy.WebsocketTester.terminate(pid)
  def start_link(url) do
    { :ok, pid } = :websocket_client.start_link(url, __MODULE__, [])
    pid
  end
  def send_text(pid, message), do: pid <- { :cmd, :text, message }
  def terminate(pid), do: pid <- { :cmd, :terminate, nil }

  #
  # Callbacks
  #
  def init(_options, _conn_state), do: { :ok, 2 }

  def websocket_handle({ :text, message }, _conn_state, state) do
    IO.puts "message received: #{inspect message}"
    { :ok, state }
  end

  def websocket_info({ :cmd, :terminate, nil }, _conn_state, state) do
    { :close, "", 10 }
  end
  def websocket_info({ :cmd, :text, message }, _conn_state, state) do
    { :reply, { :text, message }, state }
  end
  def websocket_info(_anything, _conn_state, state), do: { :ok, state }

  def websocket_terminate(_anything, _conn_state, _state), do: IO.puts "terminated"; :ok
end
