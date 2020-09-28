defmodule Awelix.Services.Repo.RepoTest do
  use ExUnit.Case, async: false

  alias Awelix.Services.Repo.Repo
  require Awelix.Pact

  setup do
    :ets.delete_all_objects(:packages)
    %{}
  end

  test "fetch packages info - failure: not initialized yet" do
    assert {:error, :not_ready_yet} = Repo.fetch()
  end

  test "fetch packages info - success" do
    Repo.update([%{}])
    result = Repo.fetch()

    assert {:ok, items} = result
    assert is_list(items)
    assert Enum.count(items) == 1
  end

  test "update facility" do
    Repo.update([%{}])
    assert {:ok, list} = Repo.fetch()
    assert Enum.count(list) == 1
  end

end
