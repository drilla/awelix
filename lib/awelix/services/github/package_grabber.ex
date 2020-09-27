defmodule Awelix.Services.Github.PackageGrabber do
  require Logger

  alias Awelix.Pact, as: Pact
  alias Awelix.Services.Packages.Package

  @limit Application.get_env(:awelix, :packages_limit)
  @parallel_requests Application.get_env(:awelix, :parallel_requests)

  ###########
  # INTERFACE
  ###########

  @spec fetch() ::
          {:ok, list()} | {:error, atom()}
  def fetch() do
    with {:ok, readme} <- Pact.github_api().fetch_readme("h4cc", "awesome-elixir"),
         {:ok, readme_packages} <- parse_readme(readme),
         {:ok, packages} <- fetch_packages(readme_packages |> limit(@limit)) do
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
      |> fetch_each_repo_stars()
      |> fetch_each_repo_last_commit_date()
      |> remove_package_errors()

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

  @spec fetch_each_repo_stars([Package.t()]) :: [Package.t() | :error]
  defp fetch_each_repo_stars(readme_packages) do
    Task.async_stream(
      readme_packages,
      fn %Package{owner: owner, repo: repo} = package ->
        case Pact.github_api().fetch_repo_info(owner, repo) do
          {:ok, %{stars: stars, branch: branch}} ->
            %Package{package | stars: stars, branch: branch}
          _ -> :error
        end
      end,
      max_concurrency: @parallel_requests
    )
    |> Enum.to_list()
    |> remove_package_errors()
    |> Enum.map(fn {_, item} -> item end)
  end

  @spec fetch_each_repo_last_commit_date([Package.t()]) :: [Package.t()]
  defp fetch_each_repo_last_commit_date(readme_packages) do
    Task.async_stream(
      readme_packages,
      fn %Package{owner: owner, repo: repo, branch: branch} = package ->
        case Pact.github_api().fetch_repo_last_commit_date(owner, repo, branch) do
          {:ok, date} -> %Package{package | last_commit_date: date}
          _ -> :error
        end
      end,
      max_concurrency: @parallel_requests
    )
    |> Enum.to_list()
    |> Enum.map(fn {_, item} -> item end)
  end

  @spec remove_package_errors([{:ok, Package.t()} | {:ok, :error}]) :: [{:ok, Package.t()}]
  defp remove_package_errors(list) do
    Enum.filter(list, fn item -> item != {:ok, :error} end)
  end

  defp limit(list, nil), do: list
  defp limit(list, count), do: Enum.take(list, count)
end
