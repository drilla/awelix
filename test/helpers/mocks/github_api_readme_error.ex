defmodule Awelix.Helpers.Mocks.GithubApiReadmeError do
  @behaviour Awelix.Services.Packages.Github.GithubApiInterface

  @impl true
  def fetch_file(_, _, _) do
    {:error, %HTTPoison.Error{id: nil, reason: "any"}}
  end

  @impl true
  def fetch_repository_info(binary, binary) do
    nil
  end
end
