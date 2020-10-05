defmodule Awelix.Services.Repo.RepoUpdater do
  @moduledoc """
     обновляет информацию о репозиториях с заданной периодичностью
  """
  @behaviour Awelix.Services.Repo.RepoUpdaterInterface

  use GenServer

  alias Awelix.Pact, as: Pact

  require Logger

  require Awelix.Pact

  ###########
  # INTERFACE
  ###########

  @impl Awelix.Services.Repo.RepoUpdaterInterface
  def update_async() do
    case get_state() do
      %{updating: false} ->
        set_updating()
        GenServer.cast(__MODULE__, :update)
        {:ok, :update_started}

      %{updating: true} ->
        {:error, :updating_now}
    end
  end

  ###########
  # GENSERVER
  ###########

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

  @impl GenServer
  def init(_) do

    # вызываем разогрев кеша после инита
    case Mix.env() do
      :test -> {:ok, %{updating: false}}
      _     -> {:ok, %{updating: true}, {:continue, :warmup}}
    end
  end

  @impl GenServer
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:set_updating, value}, _from, state) do
    {:reply, :ok, Map.put(state, :updating, value)}
  end

  @impl GenServer
  def handle_cast(:update, state) do
    do_update()
    {:noreply, state}
  end

  @impl GenServer
  def handle_continue(:warmup, state) do
    do_update()
    {:noreply, %{state | updating: true}}
  end

  #########
  # PRIVATE
  #########

  defp get_state() do
    GenServer.call(__MODULE__, :state)
  end

  defp set_updating(value \\ true) do
    GenServer.call(__MODULE__, {:set_updating, value})
  end

  @spec do_update() :: :ok
  defp do_update() do
    Task.start_link(fn ->
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

      set_updating(false)
    end)

    :ok
  end
end
