defmodule Awelix.Helpers.Mocks.GithubApiReadmeError do
  @behaviour Awelix.Services.Github.Graphql.ApiInterface

  @impl true
  def fetch_readme(_) do
    {:error, :github_api_error}
  end

  @impl true
  def fetch_repos_by_chunk(_) do
    {:error, :github_api_error}
  end

end
