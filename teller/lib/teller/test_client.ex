defmodule Teller.TestClient do
  @behaviour :websocket_client_handler

  def start_link do
    :websocket_client.start_link('ws://echo.websocket.org', __MODULE__, [42])
  end

  def init([num], _conn_state) do
    IO.puts "init(#{inspect num})"
    { :ok, 2 }
  end

  def websocket_handle({ :pong, _ }, _conn_state, state) do
    { :ok, state }
  end

  def websocket_handle({ :text, message }, _conn_state, :internal) do
    IO.puts ">>> internal message received: #{inspect message}"
    { :reply, { :text, "hello is is message UNO" }, 1 }
  end
  def websocket_handle({ :text, message }, _conn_state, 5) do
    IO.puts ">>> LAST message received: #{inspect message}"
    { :close, "", 10 }
  end
  def websocket_handle({ :text, message }, _conn_state, state) do
    IO.puts ">>> message received: #{inspect message}"
    { :reply, { :text, "hello is is message ##{state}" }, state + 1 }
  end

  def websocket_info(:start, _conn_state, state) do
    { :reply, { :text, "erlang message received" }, state }
  end

  def websocket_info(:internal, _conn_state, _state) do
    { :reply, { :text, "from myself" }, :internal }
  end

  def websocket_info({ :function, f }, _conn_state, state) do
    IO.puts ">>> function = #{inspect f}"
    f.(:param)
    { :reply, { :text, "function executed" }, state }
  end

  def websocket_terminate(something, _conn_state, state) do
    IO.puts "something(#{inspect something}) state(#{inspect state})"
    :ok
  end
end
