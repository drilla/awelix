defmodule Awelix.Services.Packages.Github.GithubApi do
  alias Awelix.Pact, as: Pact

  require Logger

  @behaviour Awelix.Services.Packages.Github.GithubApiInterface

  @github_url "https://api.github.com"
  @git_token System.get_env("GIT_TOKEN")
  @impl true
  def fetch_readme(owner, repo) do
    with url <- readme_url(owner, repo),
         {:ok, %HTTPoison.Response{body: body}} <- Pact.http_client().get(url, headers()),
         {:ok, %{"content" => base64_content}} <- Jason.decode(body),
         {:ok, decoded} <- Base.decode64(base64_content, ignore: :whitespace) do
      {:ok, decoded}
    else
      error -> recycle_error(error)
    end
  end

  @impl true
  def fetch_repo_stars(owner, repo) do
    with url <- repo_url(owner, repo),
         {:ok, %HTTPoison.Response{body: body}} <- Pact.http_client().get(url, headers()),
         {:ok, %{"stargazers_count" => stars}} <- Jason.decode(body) do
      {:ok, stars}
    else
      error -> recycle_error(error)
    end
  end

  @impl true
  def fetch_repo_last_commit_date(owner, repo) do
    with url <- master_branch_url(owner, repo),
         {:ok, %HTTPoison.Response{body: body}} <- Pact.http_client().get(url, headers()),
         {:ok, %{"commit" => %{"commit" => %{"author" => %{"date" => date_str}}}}} <-
           Jason.decode(body),
         {:ok, datetime, _} <- DateTime.from_iso8601(date_str) do
      {:ok, datetime}
    else
      error -> recycle_error(error)
    end
  end

  #########
  # PRIVATE
  #########

  defp recycle_error({:error, %HTTPoison.Error{} = error}) do
    Logger.error(inspect(error))
    {:error, :github_api_error}
  end

  defp recycle_error(error) do
    Logger.error(inspect(error))
    {:error, :other}
  end

  defp repo_url(owner, repo) do
    "#{@github_url}/repos/#{owner}/#{repo}"
  end

  defp master_branch_url(owner, repo) do
    "#{@github_url}/repos/#{owner}/#{repo}/branches/master"
  end

  defp readme_url(owner, repo) do
    "#{@github_url}/repos/#{owner}/#{repo}/readme"
  end

  defp headers() do
    [
      {"Accept", "application/vnd.github.v3+json"},
      {"Authorization", "token #{@git_token}"}
    ]
  end
end
