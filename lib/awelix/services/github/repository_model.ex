defmodule Awelix.Services.Github.RepositoryModel do
  alias Awelix.Services.Packages.Package
  @enforce_keys [:name, :owner]
  @type t :: %__MODULE__{
          name: binary,
          owner: binary,
          title: binary,
          stars: integer,
          last_commit_date: binary()
        }

  defstruct [:name, :owner, :title, :stars, :last_commit_date]

  @spec from_package(Package.t()) :: RepositoryModel.t()
  def from_package(%Package{name: name, owner: owner, title: title}) do
    %__MODULE__{
      name: name,
      owner: owner,
      title: title
    }
  end

  @spec from_git_data({any, map}) :: RepositoryModel.t()
  def from_git_data({_title, item}) do
    %{
      "defaultBranchRef" => %{
        "target" => %{"committedDate" => date}
      },
      "name" => name,
      "stargazerCount" => stars,
      "owner" => %{
        "login" => owner
      }
    } = item

    dt =
      case DateTime.from_iso8601(date) do
        {:ok, dt, _} -> dt
        _ -> nil
      end
    %__MODULE__{name: name, owner: owner, stars: stars, last_commit_date: dt}
  end
end
