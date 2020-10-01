defmodule Awelix.Services.Github.GithubApiTest do
  use ExUnit.Case

  require Awelix.Pact

  alias Awelix.Services.Github.GithubGraphqlApi, as: GithubApi
  alias Awelix.Services.Github.RepositoryModel

  alias Awelix.Helpers.Mocks.{
    HttpOkBodyCorrupt,
    HttpReadmeOk,
    HttpOkRepos,
    HttpError
  }

  describe "http ok" do
    test "fetch readme contents" do
      Awelix.Pact.register(:http, HttpReadmeOk)

      assert {:ok, "123456"} =
               GithubApi.fetch_readme(%RepositoryModel{owner: "owner", name: "repo"})
    end

    test "fetch repo info" do
      Awelix.Pact.register(:http, HttpOkRepos)
      {:ok, dt, _} = DateTime.from_iso8601("2020-09-30T10:00:32Z")

      assert {:ok,
              [
                %Awelix.Services.Github.RepositoryModel{
                  last_commit_date: dt,
                  name: "repo",
                  owner: "owner",
                  stars: 10
                }
              ]} == GithubApi.fetch_repos_by_chunk([%RepositoryModel{owner: "owner", name: "repo"}])
    end
  end

  describe "http error" do
    setup do
      Awelix.Pact.register(:http, HttpError)
      %{}
    end

    test "readme" do
      assert {:error, :github_api_error} =
               GithubApi.fetch_readme(%RepositoryModel{owner: "owner", name: "repo"})
    end

    test "info" do
      assert {:error, :github_api_error} =
               GithubApi.fetch_repos_by_chunk([%RepositoryModel{owner: "owner", name: "repo"}])
    end
  end

  describe "ohter error" do
    setup do
      Awelix.Pact.register(:http, HttpOkBodyCorrupt)
      %{}
    end

    test "readme" do
      assert {:error, :other} =
               GithubApi.fetch_readme(%RepositoryModel{owner: "owner", name: "repo"})
    end

    test "stars" do
      assert {:error, :other} =
               GithubApi.fetch_repos_by_chunk([%RepositoryModel{owner: "owner", name: "repo"}])
    end
  end
end
