defmodule Awelix.Helpers.Mocks.GithubApiReadmeOk do
  @behaviour Awelix.Services.Packages.Github.GithubApiInterface

  @impl true
  def fetch_readme(_, _) do
       # MTIzNDU2 means 123456
       {:ok, "123456"}
  end

  @impl true
  def fetch_repo_stars(_) do
    {:error, :github_api_error}
  end

  @impl true
  def fetch_repo_last_commit_date(_) do
    {:error, :github_api_error}
  end

end
