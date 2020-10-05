defmodule Awelix.Services.Github.Graphql.Query.Repos do
  alias Awelix.Services.Github.RepositoryModel

  @spec queries([RepositoryModel.t()], non_neg_integer()) :: [binary()]
  def queries(repos \\ [], chunk_size) do
      Enum.map(repos, fn %RepositoryModel{name: name, owner: owner} ->
        """
        #{json_title()}: repository(name: "#{name}", owner: "#{owner}") {
          ...RepoFragment
        }
        """
      end)
      |> Enum.chunk_every(chunk_size)
      |> Enum.map(fn chunk ->
        sub_query = chunk |> Enum.join("\n")
        """
        query {
          #{sub_query}
        }

        fragment RepoFragment on Repository {
          name
          nameWithOwner
          stargazerCount
          owner {
            login
          }
          defaultBranchRef {
            target {
              ... on Commit {
                committedDate
              }
            }
          }
        }
        """
      end)
      |> Enum.map(fn query -> %{query: query} |> Jason.encode!() end)
  end

  @spec json_title() :: binary
  defp json_title() do
    "r#{Enum.random(1..99_999_999)}"
  end
end
