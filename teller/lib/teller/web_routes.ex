defmodule Teller.WebRoutes do
  use Teller.Cowboy.Dispatch

  match "/web-socket", to: Teller.MessageDispatcherHandler
  default with: Teller.Dynamo
end
