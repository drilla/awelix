defmodule Awelix.Services.Github.GithubApiInterface do
  alias Awelix.Services.Github.RepositoryModel
  #todo doc
  @callback fetch_readme(RepositoryModel.t()) :: {:ok, binary()} | {:error, :github_api_error | :other}
  @callback fetch_repos_info([RepositoryModel.t()]) :: {:ok, [RepositoryModel.t()]} | {:error, :github_api_error | :other}
end
