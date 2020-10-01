defmodule Awelix.Helpers.Mocks.HttpOkRepos do
  def post(_, _, _, _) do
    {:ok,
     %HTTPoison.Response{
       body:
         %{
           "data" => %{
             "repo" => %{
               "defaultBranchRef" => %{
                 "target" => %{"committedDate" => "2020-09-30T10:00:32Z"}
               },
               "name" => "repo",
               "stargazerCount" => 10,
               "owner" => %{
                 "login" => "owner"
               }
             }
           }
         }
         |> Jason.encode!()
     }}
  end
end
