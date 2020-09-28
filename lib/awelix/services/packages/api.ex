defmodule Awelix.Services.Packages.Api do
  @moduledoc """
    основной модуль для работы приложения.
    предоставляет список репозиториев
  """

  alias Awelix.Services.Packages.Package
  alias Awelix.Pact, as: Pact

  require Logger

  require Awelix.Pact

  @doc """
     получить информацию о репозиториях.
  """
  @spec fetch() :: {:ok, list} | {:error, :not_ready_yet}
  def fetch() do
    case Pact.repo().fetch() do
      {:ok, list} ->
        {:ok, list}

      {:error, :not_ready_yet} = error ->
        # не блокируем клиента, эликсир это все таки про реактивность
        Pact.repo_updater().update_async()

        error
    end
  end

  @spec fetch(non_neg_integer()) :: {:ok, list} | {:error, :not_ready_yet}
  def fetch(min_stars) do
    fetch()
    |> filter_by_min_stars(min_stars)
  end

  defp filter_by_min_stars({:ok, list}, min_stars) do
    {:ok, Enum.filter(list, fn %Package{stars: stars} -> stars >= min_stars end)}
  end

  defp filter_by_min_stars({:error, _} = result, _min_stars), do: result
end
