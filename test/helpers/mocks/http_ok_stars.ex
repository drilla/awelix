defmodule Awelix.Helpers.Mocks.HttpOkStars do

  def get(_, _) do
    {:ok,
     %HTTPoison.Response{
       body: %{stargazers_count: 10} |> Jason.encode!()
     }}
  end
end
