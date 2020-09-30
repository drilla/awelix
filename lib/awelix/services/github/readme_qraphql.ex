  defmodule Awelix.Services.Github.ReadmeGraphql do

  alias Awelix.Services.Github.RepositoryModel

  @spec query(RepositoryModel.t()) :: binary
  def query(%RepositoryModel{name: name, owner: owner}) do
       %{
        query: ~s"""
                 {repository(name: "#{name}", owner: "#{owner}") {
                   object(expression: "master:README.md") {
                     ... on Blob {
                       contents: text
                     }
                   }
                 }
                 }
                 """
        } |> Jason.encode!()
  end
end
