defmodule Awelix.Services.Packages.Github.GithubApiTest do
  use ExUnit.Case

  require Awelix.Pact

  alias Awelix.Services.Packages.Github.GithubApi
  alias Awelix.Services.Packages.Package
  alias Awelix.Helpers.Mocks.{HttpReadmeOk, HttpOkStars, HttpError}

  describe "http ok" do
    test "fetch file contents" do
      Awelix.Pact.register(:http, HttpReadmeOk)

      assert {:ok, "123456"} = GithubApi.fetch_readme("owner", "repo")
    end

    test "fetch repo stars" do
      Awelix.Pact.register(:http, HttpOkStars)
      assert {:ok, 10} == GithubApi.fetch_repo_stars(%Package{owner: "owner", repo: "repo"})
    end
  end

  describe "http error" do
    setup do
      Awelix.Pact.register(:http, HttpError)
      %{}
    end

    test "github api error" do
      assert {:error, :github_api_error} = GithubApi.fetch_readme("owner", "repo")
    end
  end
end
