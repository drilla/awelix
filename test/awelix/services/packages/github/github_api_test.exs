defmodule Awelix.Services.Packages.Github.GithubApiTest do
  use ExUnit.Case

  require Awelix.Pact

  alias Awelix.Services.Packages.Github.GithubApi
  alias Awelix.Helpers.Mocks.{HttpReadmeOk, HttpOkStars, HttpOkLastCommit, HttpError}

  describe "http ok" do
    test "fetch readme contents" do
      Awelix.Pact.register(:http, HttpReadmeOk)

      assert {:ok, "123456"} = GithubApi.fetch_readme("owner", "repo")
    end

    test "fetch repo stars" do
      Awelix.Pact.register(:http, HttpOkStars)
      assert {:ok, 10} == GithubApi.fetch_repo_stars("owner", "repo")
    end
    test "last commit date" do
      Awelix.Pact.register(:http, HttpOkLastCommit)
      assert {:ok, date} = GithubApi.fetch_repo_last_commit_date("owner", "repo")
      assert DateTime.to_iso8601(date) == "2020-09-15T09:35:03Z"
    end
  end

  describe "http error" do
    setup do
      Awelix.Pact.register(:http, HttpError)
      %{}
    end

    test "readme" do
      assert {:error, :github_api_error} = GithubApi.fetch_readme("owner", "repo")
    end

    test "stars" do
      assert {:error, :github_api_error} = GithubApi.fetch_repo_stars("owner", "repo")
    end

    test "last commit" do
      assert {:error, :github_api_error} = GithubApi.fetch_repo_last_commit_date("owner", "repo")
    end
  end
end
