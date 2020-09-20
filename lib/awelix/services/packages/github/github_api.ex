defmodule Awelix.Services.Packages.Github.GithubApi do
  alias Awelix.Services.Packages.Package

  require Logger

  @behaviour Awelix.Services.Packages.Github.GithubApiInterface

  @github_url "https://api.github.com"

  @impl true
  def fetch_file(owner, repo, path) do
    file_url(owner, repo, path)
    |> HTTPoison.get(headers())
  end

  @impl true
  def fetch_repository_info(owner, repo) do
    repo_url(owner, repo)
    |> HTTPoison.get(headers())
  end

  @spec fetch_repo_stars(Package.t()) :: integer() | :error
  def fetch_repo_stars(%Package{owner: owner, repo: repo}) do
    with {:ok, %HTTPoison.Response{body: body}} <- fetch_repository_info(owner, repo),
         {:ok, %{"stargazers_count" => stars}} <- Jason.decode(body) do
      stars
    else
      error ->
        Logger.error(inspect(error))
        :error
    end
  end

  @spec fetch_repo_last_commit_date(Package.t()) :: DateTime.t()| :error
  def fetch_repo_last_commit_date(%Package{} = _package) do
    DateTime.utc_now()
  end

  defp file_url(owner, repo, path) do
    "#{@github_url}/repos/#{owner}/#{repo}/contents/#{path}"
  end

  defp repo_url(owner, repo) do
    "#{@github_url}/repos/#{owner}/#{repo}"
  end

  defp headers() do
    [{"Accept", "application/vnd.github.v3+json"}]
  end
end
