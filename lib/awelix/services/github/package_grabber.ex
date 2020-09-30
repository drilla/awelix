defmodule Awelix.Services.Github.PackageGrabber do
  @moduledoc """
    Загружает информацию о репозиториях, описанных в awesome-elixir из github
  """
  require Logger

  alias Awelix.Pact, as: Pact
  alias Awelix.Services.Packages.Package
  alias Awelix.Services.Github.RepositoryModel

  @limit Application.get_env(:awelix, :packages_limit)
  @offset Application.get_env(:awelix, :packages_offset)

  ###########
  # INTERFACE
  ###########

  @doc """
    извлекает информацию о репозиториях из readme и загружает информацию по каждому
    Фильтрует не-гит репозитории, а также не найденные в гит
  """
  @spec fetch() ::
          {:ok, list()} | {:error, atom()}
  def fetch() do
    with {:ok, readme} <- Pact.github_api().fetch_readme(%RepositoryModel{owner: "h4cc", name: "awesome-elixir"}),
         {:ok, readme_packages} <- parse_readme(readme),
         {:ok, packages} <- fetch_packages(readme_packages |> limit(@limit, @offset)) do
      {:ok, packages}
    else
      {:error, _reason} = result ->
        result
    end
  end

  #########
  # PRIVATE
  #########

  @spec fetch_packages(list) :: {:ok, [Package.t()]} | {:error, atom()}
  defp fetch_packages(readme_packages) do
    Logger.info("Packages to fetch: #{Enum.count(readme_packages)}")

    models =
      readme_packages
      |> fetch_each_repo_info()

    {:ok, models}
  end

  @spec parse_readme(binary()) :: {:ok, list} | {:error, :cannot_decode}
  defp parse_readme(contents) do
    case Pact.github_readme_packages_extractor().extract(contents) do
      {:ok, []} ->
        Logger.error("readme packages appears to be empty. Parsing error?")
        {:error, :other}

      {:ok, list_of_packages} ->
        {:ok, list_of_packages}
    end
  end

  @spec fetch_each_repo_info([Package.t()]) :: [Package.t() | :error]
  defp fetch_each_repo_info(readme_packages) do
    Pact.github_api().fetch_repos_info(readme_packages)
    |> update_packages(readme_packages)
  end

  defp update_packages({:ok, fetched_data}, packages) do
    indexed_data =
      Enum.reduce(fetched_data, %{}, fn %{name: name} = item, acc ->
        Map.put(acc, name, item)
      end)

    packages
    |> Enum.map(fn %Package{name: name} = package ->
      case Map.get(indexed_data, name) do
        %{stars: stars, last_commit_date: date} ->
          %Package{package | stars: stars, last_commit_date: date}
        nil ->
          Logger.info("not found in api:#{name} #{package.url}")
          nil
      end
    end)
    |> Enum.filter(fn item -> item != nil end)

  end

  defp limit(list, limit, nil), do: limit(list, limit, 0)
  defp limit(list, nil, offset), do: limit(list, Enum.count(list), offset)
  defp limit(list, limit, offset) do
    total = Enum.count(list)
    list
    |> Enum.reverse()
    |> Enum.take(total - offset)
    |> Enum.reverse()
    |> Enum.take(limit)
  end
end
