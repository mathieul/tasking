defmodule Wspubsub.Web.HttpHandler do
  @behaviour :cowboy_http_handler

  alias Wspubsub.Pubsub

  def init({:tcp, :http}, req, _opts) do
    {:ok, req, :undefined_state}
  end

  def handle(req, state) do
    sid = get_param!(req, "sid")
    msg = get_param!(req, "msg")
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

  defp get_param!(req, name) do
    { value, _ } = :cowboy_req.qs_val(name, req, nil)
    value
  end
end
