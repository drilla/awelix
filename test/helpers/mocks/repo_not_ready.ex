defmodule Awelix.Helpers.Mocks.RepoNotReady do
  alias Awelix.Services.Packages.Package

  @behaviour Awelix.Services.Packages.RepoInterface

  @impl true
  def fetch() do
    {:error, :not_ready_yet}
  end

  @impl true
  def update(_) do
    true
  end
end
