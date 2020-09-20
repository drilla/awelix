defmodule Awelix.Services.Packages.RepoInterface do
  alias Awelix.Services.Packages.Package

  @doc """
    получить из хранилища информацию о пакетах awesome-elixir
  """
  @callback fetch() :: {:ok, [Package.t()]} | {:error, :not_ready_yet}

  @doc """
    обновить информацию о пакетах  awesome-elixir в хранишище
  """
  @callback update([Package.t()]) :: boolean()
end
