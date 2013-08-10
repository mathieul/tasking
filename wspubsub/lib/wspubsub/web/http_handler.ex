defmodule Wspubsub.Web.HttpHandler do
  @behaviour :cowboy_http_handler

  def init({:tcp, :http}, req, _opts) do
    {:ok, req, :undefined_state}
  end

  def handle(req, state) do
    { :ok, req } = :cowboy_req.reply(200, [], "Hi there!", req)
    { :ok, req, state }
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
