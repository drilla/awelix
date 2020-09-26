defmodule Awelix.Helpers.Mocks.HttpOkStars do

  def get(_, _, _) do
    {:ok,
     %HTTPoison.Response{
       body: %{stargazers_count: 10, default_branch: "branch"} |> Jason.encode!()
     }}
  end
end
