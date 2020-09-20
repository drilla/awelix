defmodule Awelix.Services.Packages.RepoUpdaterInterface do
  @callback update_async() :: {:ok, :update_started}
end
