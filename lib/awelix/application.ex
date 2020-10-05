defmodule Awelix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Awelix.Services.Repo.Repo.init_table()

    children = [
      Awelix.Pact,
      # Start the PubSub system
      {Phoenix.PubSub, name: Awelix.PubSub},

      # Start the Endpoint (http/https)
      AwelixWeb.Endpoint,

      # Start a worker by calling: Awelix.Worker.start_link(arg)
      # {Awelix.Worker, arg}
      Awelix.Services.Repo.RepoUpdater,
      Awelix.Services.Repo.RepoUpdatePeriodical,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Awelix.Supervisor]
    result = Supervisor.start_link(children, opts)

    #Awelix.Services.Repo.RepoUpdater.update_async()

    result
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AwelixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
