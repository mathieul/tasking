defmodule Teller.Cowboy.WebsocketTester do
  @behaviour :websocket_client_handler

  #
  # Public API
  #
  # i.e.:
  # > alias Teller.Cowboy.WebsocketTester
  # > pid = WebsocketTester.start_link('ws://echo.websocket.org')
  # > WebsocketTester.send_text(pid, "il etait un petit navire...")
  # > WebsocketTester.close(pid)
  def start_link(url) do
    { :ok, pid } = :websocket_client.start_link(url, __MODULE__, [])
    pid
  end
  def send_text(pid, message), do: pid <- { :cmd, :text, message }
  def close(pid), do: pid <- { :cmd, :close, nil }
  def text_spy_on(pid), do: pid <- { :cmd, :set_caller, self }
  def text_spy_off(pid), do: pid <- { :cmd, :set_caller, nil }
  def wait_for_text(error // "text message was not received", callback) do
    receive do
      message -> callback.(message)
    after 100 -> raise error
    end
  end

  #
  # Callbacks
  #
  def init(_options, _conn_state), do: { :ok, nil }

  def websocket_handle({ :text, message }, _conn_state, caller) do
    if caller, do: caller <- message
    { :ok, nil }
  end

  def websocket_info({ :cmd, :close, nil }, _conn_state, _state) do
    { :close, "", 10 }
  end
  def websocket_info({ :cmd, :text, message }, _conn_state, state) do
    { :reply, { :text, message }, state }
  end
  def websocket_info({ :cmd, :set_caller, caller }, _conn_state, _state) do
    { :ok, caller }
  end
  def websocket_info(_anything, _conn_state, state), do: { :ok, state }

  def websocket_terminate(_anything, _conn_state, _state), do: :ok
end
