defmodule Awelix.Helpers.Mocks.GithubApiReadmeOk do

  alias  Awelix.Services.Github.RepositoryModel
  @behaviour Awelix.Services.Github.Graphql.ApiInterface

  @impl true
  def fetch_readme(_) do
       # MTIzNDU2 means 123456
       {:ok, "123456"}
  end

  @impl true
  def fetch_repos_by_chunk(_) do
    {:ok, [%RepositoryModel{name: "", owner: "", stars: 10}]}
  end

end
