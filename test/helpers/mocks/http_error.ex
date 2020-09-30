defmodule Awelix.Helpers.Mocks.HttpError do

  def post(_, _, _, _) do
    {:error,
     %HTTPoison.Error{
       reason: "test",
       id: nil
     }}
  end
end
