defmodule Wspubsub.Web.WebsocketHandler do
  @behaviour :cowboy_websocket_handler

  alias Wspubsub.Pubsub

  def init({:tcp, :http}, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_transport_name, req, _opts) do
    { sid, _ } = :cowboy_req.qs_val("sid", req, nil)
    if sid, do: Pubsub.register(sid, self)
    { :ok, req, { sid } }
  end

  def websocket_handle( { :text, message }, req, state) do
    { :reply, {:text, message }, req, state }
  end
  def websocket_handle(_data, req, state), do: { :ok, req, state}

  def websocket_info({ :pubsub_message, message }, req, state) do
    { :reply, { :text, message }, req, state }
  end
  def websocket_info(_data, req, state), do: { :ok, req, state }

  def websocket_terminate(_reason, _req, _state), do: :ok
end
