defmodule Teller.Mixfile do
  use Mix.Project

  def project do
    [ app: :teller,
      version: "0.0.1",
      dynamos: [Teller.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/teller/ebin",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo],
      mod: { Teller, [] },
      registered: [ :pubsub ] ]
  end

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, "0.1.0-dev", github: "elixir-lang/dynamo" },
      { :websocket_client, github: "jeremyong/websocket_client" } ]
  end
end
