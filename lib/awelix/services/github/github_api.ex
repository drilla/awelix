defmodule Awelix.Services.Github.GithubApi do
  alias Awelix.Pact, as: Pact

  require Logger

  @behaviour Awelix.Services.Github.GithubApiInterface

  @github_url "https://api.github.com"
  @git_token System.get_env("GIT_TOKEN")
  @impl true
  def fetch_readme(owner, repo) do
    with url <- readme_url(owner, repo),
         {:ok, %HTTPoison.Response{body: body}} <-
           Pact.http_client().get(url, headers(), follow_redirect: true),
         {:ok, %{"content" => base64_content}} <- Jason.decode(body),
         {:ok, decoded} <- Base.decode64(base64_content, ignore: :whitespace) do
      {:ok, decoded}
    else
      error -> recycle_error(error)
    end
  end

  @impl true
  def fetch_repo_info(owner, repo) do
    url = repo_url(owner, repo)

    with {:ok, %HTTPoison.Response{body: body}} <-
           Pact.http_client().get(url, headers(), follow_redirect: true),
         {:ok, %{"stargazers_count" => stars, "default_branch" => branch}} <- Jason.decode(body) do
      Logger.info("stars fethced: #{url}")
      {:ok, %{stars: stars, branch: branch}}
    else
      error -> recycle_error(error, url)
    end
  end

  @impl true
  def fetch_repo_last_commit_date(owner, repo, branch) do
    url = branch_url(owner, repo, branch)

    with {:ok, %HTTPoison.Response{body: body}} <-
           Pact.http_client().get(url, headers(), follow_redirect: true),
         {:ok, %{"commit" => %{"commit" => %{"author" => %{"date" => date_str}}}}} <-
           Jason.decode(body),
         {:ok, datetime, _} <- DateTime.from_iso8601(date_str) do
      Logger.info("datetime fethced: #{url}")
      {:ok, datetime}
    else
      error ->
        recycle_error(error, url)
    end
  end

  #########
  # PRIVATE
  #########

  defp recycle_error(error, url) do
    Logger.error(url)
    recycle_error(error)
  end

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

  defp branch_url(owner, repo, branch) do
    "#{@github_url}/repos/#{owner}/#{repo}/branches/#{branch}"
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
