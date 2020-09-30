defmodule Awelix.Helpers.Mocks.GithubApiReadmeOk do

  alias  Awelix.Services.Github.RepositoryModel
  @behaviour Awelix.Services.Github.GithubApiInterface

  @impl true
  def fetch_readme(_) do
       # MTIzNDU2 means 123456
       {:ok, "123456"}
  end

  @impl true
  def fetch_repos_info(_) do
    {:ok, [%RepositoryModel{name: "", owner: "", stars: 10}]}
  end

end
