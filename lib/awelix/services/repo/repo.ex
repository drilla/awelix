defmodule Awelix.Services.Repo.Repo do
  @behaviour Awelix.Services.Repo.RepoInterface

  @ets_table :packages

  @impl true
  def fetch() do
    case :ets.lookup(@ets_table, :items) do
      [{_key, []}] -> {:error, :not_ready_yet}
      [{_key, items}] when is_list(items) -> {:ok, items}
      _ -> {:error, :not_ready_yet}
    end
  end

  @impl true
  def update(items) do
    :ets.insert(@ets_table, [{:items, items}, {:updated_at, DateTime.utc_now()}])
  end

  def init_table() do
    :ets.new(@ets_table, [:set, :public, :named_table])
  end
end
