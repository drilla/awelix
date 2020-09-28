defmodule Awelix.Services.Repo.RepoUpdater do
  @moduledoc """
     обновляет информацию о репозиториях с заданной периодичностью
  """
  @behaviour Awelix.Services.Repo.RepoUpdaterInterface

  @periodic_update Application.get_env(:awelix, __MODULE__, [])

  use GenWorker,
    @periodic_update


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
    Task.async(__MODULE__, :update, [])
    {:ok, :update_started}
  end

  @spec update() ::  {:error, atom()} | true
  def update() do

      result = Pact.github_package_grabber().fetch()

      case result do
        {:ok, packages} ->
          Pact.repo().update(packages)

        {:error, reason} ->
          Logger.error("info update failed")
          Logger.error(inspect(reason))
          {:error, reason}
      end
  end
end
