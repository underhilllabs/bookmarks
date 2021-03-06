defmodule Bookmarks.Mixfile do
  use Mix.Project

  def project do
    [app: :bookmarks,
     version: "0.0.3",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Bookmarks, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext, :scrivener_html,
                    :scrivener_ecto, :comeonin, :phoenix_ecto, :timex, :readability, :postgrex,
                    :secure_random]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.3.2", override: true},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.2"},
     {:poison, "~> 2.0"},
     {:postgrex, "~> 0.13.3"},
     {:phoenix_html, "~> 2.10"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:guardian, "~> 0.13.0"},
     {:comeonin, "~> 2.6"},
     {:gettext, "~> 0.11"},
     {:timex, "~> 3.0"},
     {:distillery, "~> 1.5.4"},
     {:secure_random, "~> 0.5"},
     {:readability, "~> 0.9.1"},
     {:scrivener_ecto, "~> 1.0"},
     {:scrivener_html, "~> 1.1"},
     {:ex_spec, "~> 2.0", only: :test},
     {:cowboy, "~> 1.0"}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
