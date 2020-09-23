defmodule Awelix.Services.Packages.Github.PackageGrabberTest do
  use ExUnit.Case

  require Awelix.Pact

  alias Awelix.Services.Packages.Github.PackageGrabber
  alias Awelix.Helpers.Mocks.{GithubApiReadmeOk, GithubApiReadmeError}

  describe "fetch packages - success" do
    setup do
      Awelix.Pact.register(:github_api, GithubApiReadmeOk)

      extractor =
        Awelix.Pact.generate :github_readme_packages_extractor do
          def extract(_body) do
            {:ok, []}
          end
        end

      Awelix.Pact.register(:github_readme_packages_extractor, extractor)

      %{}
    end

    test "fetch packages - success" do
      assert {:ok, packages} = PackageGrabber.fetch()
      assert is_list(packages)
    end
  end

  describe "github api errors " do
    setup do
      extractor =
        Awelix.Pact.generate :github_readme_packages_extractor do
          def extract(_body) do
            {:ok, []}
          end
        end

      Awelix.Pact.register(:github_api, GithubApiReadmeError)
      Awelix.Pact.register(:github_readme_packages_extractor, extractor)
      %{}
    end

    test "github api error" do
      assert {:error, :github_api_error} = PackageGrabber.fetch()
    end
  end
end
