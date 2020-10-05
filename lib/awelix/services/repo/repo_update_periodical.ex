defmodule Awelix.Services.Repo.RepoUpdatePeriodical do
  @moduledoc """
     обновляет информацию о репозиториях с заданной периодичностью
  """

  @periodic_update Application.get_env(:awelix, __MODULE__, [])

  use GenWorker,
    @periodic_update

  def run(_) do
    if Mix.env() != :test do
      Awelix.Services.Repo.RepoUpdater.update_async()
    end
  end
end
