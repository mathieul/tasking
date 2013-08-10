defmodule Wspubsub.Web do
  def run do
    dispatch = :cowboy_router.compile([
      { :_, [
        { "/publish", Wspubsub.Web.HttpHandler, [] },
        { "/web-socket", Wspubsub.Web.WebsocketHandler, [] }
        ] }
    ])
    port = Mix.project[:web][:port] || 8000
    :cowboy.start_http(:http, 100, [port: port], [env: [dispatch: dispatch]])
  end
end
