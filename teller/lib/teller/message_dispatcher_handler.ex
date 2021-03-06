defmodule Teller.MessageDispatcherHandler do
  @behaviour :cowboy_websocket_handler

  def init({:tcp, :http}, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_transport_name, req, _opts) do
    { room_id, _ } = :cowboy_req.qs_val("room_id", req, nil)
    if room_id, do: Teller.Pubsub.register(room_id, self)
    { :ok, req, room_id }
  end

  def websocket_handle( { :text, message }, req, state) do
    { :reply, {:text, message }, req, state }
  end
  def websocket_handle(_data, req, state), do: { :ok, req, state}

  def websocket_info({ :pubsub_message, message }, req, state) do
    { :reply, { :text, message }, req, state }
  end
  def websocket_info(_data, req, state), do: { :ok, req, state }

  def websocket_terminate(_reason, _req, room_id) do
    Teller.Pubsub.unregister(room_id, self)
    :ok
  end
end
