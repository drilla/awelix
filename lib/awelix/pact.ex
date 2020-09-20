defmodule Awelix.Pact do
  use Pact

  register(:http, HTTPoison)
  register(:repo, Awelix.Services.Packages.Repo)
  register(:repo_updater, Awelix.Services.Packages.RepoUpdater)
  register(:github_package_grabber, Awelix.Services.Packages.Github.PackageGrabber)
  register(:github_readme_packages_extractor, Awelix.Services.Packages.Github.Readme.PackagesExtractor)
  register(:github_api,             Awelix.Services.Packages.Github.GithubApi)

  @doc """
    :: Awelix.Services.Packages.RepoInterface
  """
  def repo(), do: Awelix.Pact.get(:repo)

  def repo_updater(), do: Awelix.Pact.get(:repo_updater)

  def http_client(), do: Awelix.Pact.get(:http)

  def github_package_grabber(), do: Awelix.Pact.get(:github_package_grabber)

  def github_api(), do: Awelix.Pact.get(:github_api)

  def github_readme_packages_extractor(), do: Awelix.Pact.get(:github_readme_packages_extractor)
end

Awelix.Pact.start_link()
