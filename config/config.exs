# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# see genworker docs
config :awelix, Awelix.Services.Repo.RepoUpdater,
  run_at: %{"daily" => [hour: 0, minute: 0]}

config :awelix,
  packages_limit: nil,
  packages_offset: nil,
  git_repos_at_one_time: 200,
  git_token: nil

# Configures the endpoint
config :awelix, AwelixWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 4000],
  secret_key_base: "mdLVOckrsuzrojCDq1+9GH+icQI3l9GFehLdXkoOvDTI/GQfRfCzdYTZYKY1MedN",
  render_errors: [view: AwelixWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Awelix.PubSub,
  live_view: [signing_salt: "qTZqhlbK"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
import_config "config.secret.exs"
