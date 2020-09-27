defmodule Awelix.Services.Repo.RepoUpdater do
  @behaviour Awelix.Services.Repo.RepoUpdaterInterface

  use GenWorker,
    run_at: %{"daily" => [hour: 0, minute: 0]}

  alias Awelix.Pact, as: Pact

  require Logger

  require Awelix.Pact

  def run(_) do
    if Mix.env() != :test do
      update_async()
    end
  end

  @spec update_async() :: {:ok, :update_started}
  def update_async() do
    Task.async(fn ->
      result = Pact.github_package_grabber().fetch()

      case result do
        {:ok, packages} ->
          Pact.repo().update(packages)

        {:error, reason} ->
          Logger.error("info update failed")
          Logger.error(inspect(reason))
      end
    end)

    {:ok, :update_started}
  end
end
