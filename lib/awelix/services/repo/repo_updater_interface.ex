defmodule Awelix.Services.Repo.RepoUpdaterInterface do
  @callback update_async() :: {:ok, :update_started}
end
