defmodule Awelix.Services.Github.GithubGraphqlApi do
  @moduledoc """
    запрашиваем информацию у github
  """

  alias Awelix.Pact, as: Pact

  alias Awelix.Services.Github.ReadmeGraphql
  alias Awelix.Services.Github.ReposGraphql
  alias Awelix.Services.Github.RepositoryModel
  alias Awelix.Services.Github.RepositoryModelAdapter
  require Logger

  @behaviour Awelix.Services.Github.GithubApiInterface

  @api_url "https://api.github.com/graphql"
  @git_token System.get_env("GIT_TOKEN")

  @doc """
    получаем контент readme
  """
  @impl true
  def fetch_readme(%RepositoryModel{} = repo) do
    with {:ok, %HTTPoison.Response{body: body}} <-
           Pact.http_client().post(@api_url, ReadmeGraphql.query(repo), headers(),
             follow_redirect: true
           ),
         {:ok, %{"data" => %{"repository" => %{"object" => %{"contents" => content}}}}} <-
           Jason.decode(body) do
      {:ok, content}
    else
      error -> recycle_error(error)
    end
  end

  @impl true
  def fetch_repos_by_chunk(repos) do
    result =
      repos
      |> ReposGraphql.query()
      |> Enum.map(&fetch_chunk/1)
      |> Enum.map(fn
        {:ok, list} -> list
        error -> error
      end)

    if Enum.all?(result, fn
         list when is_list(list) -> true
         _ -> false
       end) do
      {:ok, Enum.concat(result)}
    else
      result |> hd()
    end
  end

  #########
  # PRIVATE
  #########

  defp fetch_chunk(query) do
    opts = [follow_redirect: true, timeout: 20000, recv_timeout: 20000]

    with {:ok, %HTTPoison.Response{body: body}} <-
           Pact.http_client().post(@api_url, query, headers(), opts),
         {:ok, %{"data" => packages_with_title}} <- Jason.decode(body) do
      packages =
        packages_with_title
        |> Map.to_list()
        |> Enum.filter(fn {_title, item} -> item != nil end)
        |> Enum.map(&RepositoryModelAdapter.from_git_data(&1))

      {:ok, packages}
    else
      error -> recycle_error(error)
    end
  end

  defp recycle_error({:error, %HTTPoison.Error{} = error}) do
    Logger.error(inspect(error))
    {:error, :github_api_error}
  end

  defp recycle_error(error) do
    Logger.error(inspect(error))
    {:error, :other}
  end

  defp headers() do
    [
      {"Accept", "application/vnd.github.v3+json"},
      {"Authorization", "token #{@git_token}"}
    ]
  end
end
