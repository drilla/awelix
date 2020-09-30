defmodule Awelix.Helpers.Mocks.GithubApiReadmeError do
  @behaviour Awelix.Services.Github.GithubApiInterface

  @impl true
  def fetch_readme(_) do
    {:error, :github_api_error}
  end

  @impl true
  def fetch_repos_info(_) do
    {:error, :github_api_error}
  end

end
