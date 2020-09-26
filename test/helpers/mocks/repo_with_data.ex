defmodule Awelix.Helpers.Mocks.RepoWithData do
  alias Awelix.Services.Packages.Package

  @behaviour Awelix.Services.Repo.RepoInterface

  @impl true
  def fetch() do
    {:ok, [
      %Package{name: "test", category: "actors", url: "http://localhost", stars: 10, last_commit_date: DateTime.utc_now()},
      %Package{name: "test2", category: "actors", url: "http://localhost", stars: 20, last_commit_date: DateTime.utc_now()},
      %Package{name: "test3", category: "web", url: "http://localhost", stars: 30, last_commit_date: DateTime.utc_now()},
      %Package{name: "test3", category: "web", url: "http://localhost", stars: 40, last_commit_date: DateTime.utc_now()},
      %Package{name: "test3", category: "web", url: "http://localhost", stars: 50, last_commit_date: DateTime.utc_now()}
    ]}
  end

  @impl true
  def update(_) do
    true
  end
end
