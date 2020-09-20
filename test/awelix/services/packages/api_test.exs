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

    test "fetch packages info - success" do
      result = Api.fetch()

      assert {:ok, items} = result
      assert is_list(items)
      assert Enum.count(items) == 5

    end

    test "fetch packages info with min_stars - success" do
      result = Api.fetch(30)

      assert {:ok, items} = result
      assert is_list(items)
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

  end

end
