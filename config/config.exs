# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :bookmarks,
  ecto_repos: [Bookmarks.Repo]

# Configures the endpoint
config :bookmarks, Bookmarks.Endpoint,
  url: [host: "bookmarks.denvertech.org"],
  secret_key_base: "klh8Qs4mdnM1Ry/rhn0z1Q4Kg/pMY4YRn9uHrfIKXUvIYNJxd/J/Gy7K/h6sxNUT",
  render_errors: [view: Bookmarks.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bookmarks.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure guardian
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Unicorn",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: "GFirMsmChzWa36UMMLrOtnquifGm+yF4eHpjL7Po2IoIN8jOTaGKD+dIknVFYZ8h",
  serializer: Bookmarks.GuardianSerializer

config :scrivener_html,
  routes_helper: BigSnips.Router.Helpers

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
