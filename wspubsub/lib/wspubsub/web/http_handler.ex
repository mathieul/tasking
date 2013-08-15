defmodule Wspubsub.Web.HttpHandler do
  @behaviour :cowboy_http_handler

  alias Wspubsub.Pubsub

  def init({:tcp, :http}, req, _opts) do
    {:ok, req, :undefined_state}
  end

  def handle(req, state) do
    { room_id, data } = get_room_id_and_data(req)
    if room_id && data do
      Pubsub.publish(room_id, data)
      { :ok, req } = :cowboy_req.reply(200, [], "sent", req)
    else
      { :ok, req } = :cowboy_req.reply(406, [], "406 Not Acceptable", req)
    end
    { :ok, req, state }
  end

  def terminate(_reason, _req, _state) do
    :ok
  end

  defp get_room_id_and_data(req) do
    { :ok, params, _ } = :cowboy_req.body_qs(req)
    if Enum.empty?(params), do: { params, _ } = :cowboy_req.qs_vals(req)
    values = Enum.reduce params, {nil, nil}, fn { name, value }, acc ->
      { room_id, data } = acc
      case name do
        "room_id" -> { value, data }
        "data" -> { room_id, value }
        _ -> acc
      end
    end
  end
end
