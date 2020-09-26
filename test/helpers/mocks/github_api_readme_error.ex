defmodule Awelix.Helpers.Mocks.GithubApiReadmeError do
  @behaviour Awelix.Services.Packages.Github.GithubApiInterface

  @impl true
  def fetch_readme(_, _) do
    {:error, :github_api_error}
  end

  @impl true
  def fetch_repo_info(_, _) do
    {:error, :github_api_error}
  end

  @impl true
  def fetch_repo_last_commit_date(_, _) do
    {:error, :github_api_error}
  end
end
