defmodule Teller.Dynamo do
  use Dynamo

  config :dynamo,
    # The environment this Dynamo runs on
    env: Mix.env,

    # The OTP application associated with this Dynamo
    otp_app: :teller,

    # The endpoint to dispatch requests to
    endpoint: ApplicationRouter,

    # The route from which static assets are served
    # You can turn off static assets by setting it to false
    static_route: "/static"

  config :server,
    # Application handlers and routers dispatching
    dispatch: Teller.WebRoutes.dispatch

  # Uncomment the lines below to enable the cookie session store
  # config :dynamo,
  #   session_store: Session.CookieStore,
  #   session_options:
  #     [ key: "_teller_session",
  #       secret: "W7deHgvk4wlEKRFNicmt0ofMAMOZymv/InrS2AOgI05xFemYTVWPukcbPgUQPDtx"]

  # Default functionality available in templates
  templates do
    use Dynamo.Helpers
  end
end
