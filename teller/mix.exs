defmodule Teller.Mixfile do
  use Mix.Project

  def project do
    [ app: :teller,
      version: "0.0.1",
      dynamos: [Teller.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/teller/ebin",
      deps: deps(Mix.env) ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo],
      mod: { Teller, [] },
      registered: [ :pubsub ] ]
  end

  def deps(:prod) do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, "0.1.0-dev", github: "elixir-lang/dynamo" } ]
  end

  def deps(_) do
    deps(:prod) ++
      [ { :mimetypes, github: "spawngrid/mimetypes", override: true },
        { :hackney, github: "benoitc/hackney" },
        { :websocket_client, github: "jeremyong/websocket_client" } ]
  end
end
