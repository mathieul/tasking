defmodule Wspubsub.Web.HttpHandler do
  @behaviour :cowboy_http_handler

  alias Wspubsub.Pubsub

  def init({:tcp, :http}, req, _opts) do
    {:ok, req, :undefined_state}
  end

  def handle(req, state) do
    { sid, req } = :cowboy_req.qs_val("sid", req, nil)
    { msg, req } = :cowboy_req.qs_val("msg", req, nil)
    if sid && msg do
      Pubsub.publish(sid, msg)
      { :ok, req } = :cowboy_req.reply(200, [], "sent", req)
    else
      { :ok, req } = :cowboy_req.reply(406, [], "406 Not Acceptable", req)
    end

    { :ok, req, state }
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
