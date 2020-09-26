defmodule Awelix.Services.Github.GithubApiInterface do
  #todo doc
  @callback fetch_readme(binary(), binary()) :: {:ok, binary()} | {:error, :github_api_error | :other}
  @callback fetch_repo_info(binary(), binary()) :: {:ok, integer()} | {:error, :github_api_error | :other}
  @callback fetch_repo_last_commit_date(binary(), binary(), binary()) :: {:ok, DateTime.t()} | {:error, :github_api_error | :other}
end
