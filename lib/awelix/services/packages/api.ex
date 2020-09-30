defmodule Awelix.Services.Packages.Api do
  @moduledoc """
    основной модуль для работы приложения.
    предоставляет список репозиториев
  """

  alias Awelix.Services.Packages.Package
  alias Awelix.Services.Packages.Category
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

  @spec fetch_categories(non_neg_integer() | nil) ::
          {:ok, [Category.t()]} | {:error, :not_ready_yet}
  def fetch_categories(min_stars \\ nil) do
    case fetch() do
      {:ok, items} ->
        categories =
          items
          |> filter_by_min_stars(min_stars)
          |> group_by_category()
          |> sort_by_category()

        {:ok, categories}

      error ->
        error
    end
  end

  defp filter_by_min_stars(list, nil), do: list

  defp filter_by_min_stars(list, min_stars) when is_integer(min_stars) do
    Enum.filter(list, fn %Package{stars: stars} -> stars >= min_stars end)
  end

  @spec group_by_category([Package.t()]) :: [{binary(), [Package.t()]}]
  defp group_by_category(packages) do
    Enum.group_by(packages, &Map.get(&1, :category))
    |> Map.to_list()
    |> Enum.map(fn {name, items} -> %Category{name: name, items: items} end)
  end

  defp sort_by_category(list) do
    Enum.sort_by(list, fn %Category{name: name} -> name end)
  end
end
