# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :awelix,
  parallel_requests: 300

# see genworker docs
config :awelix, Awelix.Services.Repo.RepoUpdater,
  run_at: %{"daily" => [hour: 0, minute: 0]}

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
