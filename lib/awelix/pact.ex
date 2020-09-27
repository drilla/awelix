defmodule Awelix.Pact do
  use Pact

  register(:http, HTTPoison)
  register(:repo, Awelix.Services.Repo.Repo)
  register(:repo_updater, Awelix.Services.Repo.RepoUpdater)
  register(:github_package_grabber, Awelix.Services.Github.PackageGrabber)
  register(:github_readme_packages_extractor, Awelix.Services.Github.Readme.PackagesExtractor)
  register(:github_api, Awelix.Services.Github.GithubApi)

  @doc """
    :: Awelix.Services.Repo.RepoInterface
  """
  def repo(), do: Awelix.Pact.get(:repo)

  def repo_updater(), do: Awelix.Pact.get(:repo_updater)

  def http_client(), do: Awelix.Pact.get(:http)

  def github_package_grabber(), do: Awelix.Pact.get(:github_package_grabber)

  def github_api(), do: Awelix.Pact.get(:github_api)

  def github_readme_packages_extractor(), do: Awelix.Pact.get(:github_readme_packages_extractor)

  def child_spec() do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [], name: __MODULE__}
    }
  end

  def start_link(_args) do
    start_link()
  end

end

# Awelix.Pact.start_link()
