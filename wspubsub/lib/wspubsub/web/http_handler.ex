defmodule Wspubsub.Web.HttpHandler do
  @behaviour :cowboy_http_handler

  alias Wspubsub.Pubsub

  def init({:tcp, :http}, req, _opts) do
    {:ok, req, :undefined_state}
  end

  def handle(req, state) do
    { sid, msg } = get_sid_and_msg(req)
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

  defp get_sid_and_msg(req) do
    { :ok, params, _ } = :cowboy_req.body_qs(req)
    if Enum.empty?(params), do: { params, _ } = :cowboy_req.qs_vals(req)
    values = Enum.reduce params, {nil, nil}, fn { name, value }, acc ->
      { sid, msg } = acc
      case name do
        "sid" -> { value, msg }
        "msg" -> { sid, value }
        _ -> acc
      end
    end
  end
end
