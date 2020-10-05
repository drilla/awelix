defmodule Awelix.Services.Github.RepositoryModel do
  @moduledoc """
  данные репозитория гитхаб
  """

  @enforce_keys [:name, :owner]
  @type t :: %__MODULE__{
          name: binary,
          owner: binary,
          stars: integer,
          last_commit_date: DateTime.t()
        }

  defstruct [:name, :owner, :title, :stars, :last_commit_date]
end
