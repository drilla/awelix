defmodule Awelix.Services.Packages.ApiTest do
  use ExUnit.Case

  require Awelix.Pact

  alias Awelix.Services.Packages.Api
  alias Awelix.Helpers.Mocks.{RepoWithData, RepoNotReady}

  describe "fetch packages - success" do
    setup do
      Awelix.Pact.register(:repo, RepoWithData)
      %{}
    end

    test "fetch all - success" do
      result = Api.fetch()

      assert {:ok, items} = result
      assert is_list(items)
      assert Enum.count(items) == 5

    end

    test "fetch categories with min_stars - success" do
      result = Api.fetch_categories(30)

      assert {:ok, cats} = result
      assert is_list(cats)
      assert Enum.count(cats) == 1
      %{items: items} = cats |> hd()

      assert Enum.count(items) == 3
    end
  end

  describe "api error - data not ready yet and command is sent to facility update" do
    setup do
      Awelix.Pact.register(:repo, RepoNotReady)

      updater =  Awelix.Pact.generate :repo_updater do
        def update_async() do
          {:ok, :update_started}
        end
      end

      Awelix.Pact.register(:repo_updater, updater)
      %{}
    end

    test "fetch packages info - failure: not initialized yet" do
      assert {:error, :not_ready_yet} = Api.fetch()
    end

    test "fetch packages min stars - failure: not initialized yet" do
      assert {:error, :not_ready_yet} = Api.fetch_categories(10)
    end
  end

end
