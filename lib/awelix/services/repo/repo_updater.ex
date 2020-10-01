defmodule Awelix.Services.Repo.RepoUpdater do
  @moduledoc """
     обновляет информацию о репозиториях с заданной периодичностью
  """
  @behaviour Awelix.Services.Repo.RepoUpdaterInterface

  use GenServer

  alias Awelix.Pact, as: Pact

  require Logger

  require Awelix.Pact

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker
    }
  end

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_) do
    {:ok, %{updating: false}}
  end

  def update_async() do
    case get_state() do
     %{updating: false} ->
      set_updating()
      GenServer.cast(__MODULE__, :update)
      {:ok, :update_started}
      e ->
        IO.inspect(e)
        {:error, :updating_now}
    end
  end

  def get_state() do
    GenServer.call(__MODULE__, :state)
  end

  defp set_updating() do
    GenServer.call(__MODULE__, :set_updating)
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:set_updating, _from, state) do
    {:reply, :ok, Map.put(state, :updating, true)}
  end

  def handle_cast(:update, state) do
    do_update()
    {:noreply, %{state | updating: false}}
  end

  @spec do_update() :: {:error, atom()} | :ok
  defp do_update() do
    result = Pact.github_package_grabber().fetch()

    case result do
      {:ok, packages} ->
        Pact.repo().update(packages)
        Logger.info("repos updated!")
        :ok

      {:error, reason} ->
        Logger.error("info update failed")
        Logger.error(inspect(reason))
        {:error, reason}
    end
  end
end
