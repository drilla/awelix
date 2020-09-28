defmodule Awelix.Services.Repo.RepoUpdaterInterface do
  @callback update_async() :: {:ok, :update_started}
  @callback update() :: true | {:error, atom()}
end
