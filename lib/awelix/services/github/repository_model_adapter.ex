defmodule Awelix.Services.Github.RepositoryModelAdapter do
  alias Awelix.Services.Github.RepositoryModel
  alias Awelix.Services.Packages.Package

  @spec from_package(Package.t()) :: RepositoryModel.t()
  def from_package(%Package{name: name, owner: owner}) do
    %RepositoryModel{
      name: name,
      owner: owner
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

    %RepositoryModel{name: name, owner: owner, stars: stars, last_commit_date: dt}
  end
end
