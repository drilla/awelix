defmodule Awelix.Services.Packages.Github.PackageGrabber do
  require Logger

  alias Awelix.Pact, as: Pact
  alias Awelix.Services.Packages.Package

  ###########
  # INTERFACE
  ###########

  @spec fetch() ::
          {:ok, list()} | {:error, atom()}
  def fetch() do
    with {:ok, readme} <- Pact.github_api().fetch_readme("h4cc", "awesome-elixir"),
         {:ok, readme_packages} <- parse_readme(readme),
         {:ok, packages} <- fetch_packages(readme_packages |> Enum.take(1)) do
      {:ok, packages}
    else
      {:error, %HTTPoison.Error{}} ->
        {:error, :github_api_error}

      {:error, _reason} = result ->
        result
    end
  end

  #########
  # PRIVATE
  #########

  @spec fetch_packages(list) :: {:ok, [Package.t()]} | {:error, atom()}
  defp fetch_packages(readme_packages) do
    models =
      readme_packages
      |> fetch_each_repo_stars()
      |> fetch_each_repo_last_commit_date()
      |> remove_package_errors()

    {:ok, models}
  end

  @spec parse_readme(binary()) :: {:ok, list} | {:error, :cannot_decode}
  defp parse_readme(contents) do
    with {:ok, list_of_packages} <- Pact.github_readme_packages_extractor().extract(contents) do
      {:ok, list_of_packages}
    else
      any ->
        Logger.error(inspect(any))
        {:error, :cannot_decode}
    end
  end

  @spec fetch_each_repo_stars([Package.t()]) :: [Package.t()]
  defp fetch_each_repo_stars(readme_packages) do
    Task.async_stream(
      readme_packages,
      fn %Package{} = package ->
        stars = Pact.github_api().fetch_repo_stars(package)
        %Package{package | stars: stars}
      end,
      max_concurrency: 10
    )
    |> Enum.to_list()
    |> Enum.map(fn {_, item} -> item end)
  end

  @spec fetch_each_repo_last_commit_date([Package.t()]) :: [Package.t()]
  defp fetch_each_repo_last_commit_date(readme_packages) do
    Task.async_stream(
      readme_packages,
      fn %Package{} = package ->
        date = Pact.github_api().fetch_repo_last_commit_date(package)
        %Package{package | last_commit_date: date}
      end,
      max_concurrency: 10
    )
    |> Enum.to_list()
    |> Enum.map(fn {_, item} -> item end)
  end

  defp remove_package_errors(list) do
    Enum.filter(list, fn item -> item != :error end)
  end
end
