defmodule Awelix.Helpers.Mocks.HttpReadmeOk do
  def post(_, _, _, _) do{:ok,
     %HTTPoison.Response{
       # MTIzNDU2 means 123456
       body: %{"data" => %{"repository" => %{"object" => %{"contents" => "123456"}}}} |> Jason.encode!()
     }}
  end
end
