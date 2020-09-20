defmodule Awelix.Services.Packages.RepoUpdater do

  @behaviour Awelix.Services.Packages.RepoUpdaterInterface

  alias Awelix.Pact, as: Pact

  require Logger

  @github_api_response_await_ms 10000

  require Awelix.Pact

  @spec update_async() :: {:ok, :update_started}
  def update_async() do
    Task.async(fn ->
      result =
        Pact.github_package_grabber().fetch()

      case result do
         :content_not_changed ->
          nil

        {:ok, packages} ->
          Pact.repo().update(packages)
        {:error, reason} ->
          Logger.error(inspect(reason))
      end
    end)
    |> Task.await(@github_api_response_await_ms)

    {:ok, :update_started}
  end
end
