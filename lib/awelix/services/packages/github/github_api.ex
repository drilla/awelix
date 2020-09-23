defmodule Awelix.Services.Packages.Github.GithubApi do
  alias Awelix.Services.Packages.Package
  alias Awelix.Pact, as: Pact

  require Logger

  @behaviour Awelix.Services.Packages.Github.GithubApiInterface

  @github_url "https://api.github.com"
  #def fetch_repo(owner, repo) do
   # with url <- repo_url(owner, repo),
    #     {:ok, %HTTPoison.Response{body: body}} <- Pact.http_client().get(url, headers()),
     #    {:ok, decoded} <- Jason.decode(body) do
     # decoded
    #else
     # error ->
     #   Logger.error(inspect(error))
      #  :error
    #end
  #end


  @impl true
  def fetch_readme(owner, repo) do
    with url <- readme_url(owner, repo),
         {:ok, %HTTPoison.Response{body: body}} <- Pact.http_client().get(url, headers()),
         {:ok, %{"content" => base64_content}} <- Jason.decode(body),
         {:ok, decoded} <- Base.decode64(base64_content) do
      {:ok, decoded}
    else
      {:error, %HTTPoison.Error{} = error} ->
        Logger.error(inspect(error))
        {:error, :github_api_error}
      error ->
        Logger.error(inspect(error))
        {:error, :other}
    end
  end

  @impl true
  def fetch_repo_stars(%Package{owner: owner, repo: repo}) do
    with url <- repo_url(owner, repo),
         {:ok, %HTTPoison.Response{body: body}} <- Pact.http_client().get(url, headers()),
         {:ok, %{"stargazers_count" => stars}} <- Jason.decode(body) do
      {:ok, stars}
    else
      error ->
        Logger.error(inspect(error))
        :error
    end
  end

  @impl true
  def fetch_repo_last_commit_date(%Package{} = _package) do
    {:ok, DateTime.utc_now()}
  end

  defp repo_url(owner, repo) do
    "#{@github_url}/repos/#{owner}/#{repo}"
  end

  defp readme_url(owner, repo) do
    "#{@github_url}/repos/#{owner}/#{repo}/reamde"
  end

  defp headers() do
    [{"Accept", "application/vnd.github.v3+json"}]
  end
end
