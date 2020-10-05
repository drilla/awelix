defmodule Awelix.Services.Repo.RepoUpdaterInterface do
  @callback update_async :: {:error, :updating_now} | {:ok, :update_started}
end
