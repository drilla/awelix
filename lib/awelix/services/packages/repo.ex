defmodule Awelix.Services.Packages.Repo do
  @behaviour Awelix.Services.Packages.RepoInterface

  @ets_table :packages

  @impl true
  def fetch() do
    case :ets.lookup(@ets_table, :items) do
      [{_key, items}] -> {:ok, items}
      _ -> {:error, :not_ready_yet}
    end
  end

  @impl true
  def update(items, checksum \\ nil) do
    :ets.insert(@ets_table, [{:items, items}, {:updated_at, DateTime.utc_now()}, {:source_sha, checksum}])
  end

end
