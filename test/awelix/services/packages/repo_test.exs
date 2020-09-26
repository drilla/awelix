defmodule Awelix.Services.Repo.RepoTest do
  use ExUnit.Case, async: false

  alias Awelix.Services.Repo.Repo
  require Awelix.Pact

  @table :packages
  setup do
    :ets.new(@table, [:set, :public, :named_table])
    %{}
  end

  test "fetch packages info - success" do
    update_ets_table_direct()
    result = Repo.fetch()

    assert {:ok, items} = result
    assert is_list(items)
    assert Enum.count(items) == 1
  end

  test "fetch packages info - failure: not initialized yet" do
    assert {:error, :not_ready_yet} = Repo.fetch()
  end

  test "update facility" do
    Repo.update([%{}])
    assert {:ok, list} = Repo.fetch()
    assert Enum.count(list) == 1
  end

  defp update_ets_table_direct() do
    :ets.insert(@table, [
      {:items, [%{}]},
      {:updated_at, DateTime.utc_now()},
    ])
  end
end
