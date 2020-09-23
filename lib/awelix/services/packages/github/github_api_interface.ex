defmodule Awelix.Services.Packages.Github.GithubApiInterface do
  @callback fetch_readme(binary(), binary()) :: {:ok, binary()} | {:error, :github_api_error | :other}
  @callback fetch_repo_stars(Package.t()) :: {:ok, integer()} | {:error, :github_api_error | :other}
  @callback fetch_repo_last_commit_date(Package.t()) :: {:ok, DateTime.t()} | {:error, :github_api_error | :other}
end
