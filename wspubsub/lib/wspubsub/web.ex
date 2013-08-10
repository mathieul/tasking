defmodule Wspubsub.Web do
  def run do
    dispatch = :cowboy_router.compile([
      { :_, [
        { "/", Wspubsub.Web.HttpHandler, [] },
        { "/web-socket", Wspubsub.Web.WebsocketHandler, [] }
        ] }
    ])
    :cowboy.start_http(:http, 100, [port: 8080], [env: [dispatch: dispatch]])
  end
end
