defmodule Awelix.Helpers.Mocks.GithubApiReadmeOk do
  @behaviour Awelix.Services.Github.GithubApiInterface

  @impl true
  def fetch_readme(_, _) do
       # MTIzNDU2 means 123456
       {:ok, "123456"}
  end

  @impl true
  def fetch_repo_info(_, _) do
    {:ok, 10}
  end

  @impl true
  def fetch_repo_last_commit_date(_, _, _) do
    {:ok, DateTime.utc_now()}
  end

end
