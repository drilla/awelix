defmodule Awelix.Services.Repo.RepoUpdaterTest do
  use ExUnit.Case, async: false

  alias Awelix.Services.Repo.RepoUpdater
  alias Awelix.Services.Packages.Package
  require Awelix.Pact

  @doc """
  тест по методу черного ящика. даже если один из сервисов ломается внутри, ответ не измениться
  """
  describe "ok" do
    setup do
      repo =
        Awelix.Pact.generate :repo do
          def update(_) do
            true
          end
        end

      grabber =
        Awelix.Pact.generate :github_package_grabber do
          def fetch() do
            {:ok, [%Awelix.Services.Packages.Package{}]}
          end
        end

      Awelix.Pact.register(:repo, repo)
      Awelix.Pact.register(:github_package_grabber, grabber)

      %{}
    end

    test "update, no failures" do
      true = RepoUpdater.update()
    end

    test "update async, no failures" do
      {:ok, :update_started} = RepoUpdater.update_async()
    end
  end

  describe "failures" do
    setup do
      repo =
        Awelix.Pact.generate :repo do
          def update(_) do
            true
          end
        end

      grabber =
        Awelix.Pact.generate :github_package_grabber do
          def fetch() do
            {:error, "test"}
          end
        end

      Awelix.Pact.register(:repo, repo)
      Awelix.Pact.register(:github_package_grabber, grabber)

      %{}
    end

    test "grabber failure" do
      {:ok, :update_started} = RepoUpdater.update_async()
      {:error, _} = RepoUpdater.update()
    end
  end
end