defmodule Wspubsub.Mixfile do
  use Mix.Project

  def project do
    [ app: :wspubsub,
      version: "0.0.1",
      elixir: "~> 0.10.2-dev",
      web: [
        port: 4000,
      ],
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      applications: [ :ranch, :cowboy ],
      mod: { Wspubsub, { [], nil } },
      registered: [ :pubsub ]
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [ { :cowboy, "0.8.6", github: "extend/cowboy" } ]
  end
end
