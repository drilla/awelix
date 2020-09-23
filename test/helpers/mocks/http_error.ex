defmodule Awelix.Helpers.Mocks.HttpError do

  def get(_, _) do
    {:error,
     %HTTPoison.Error{
       reason: "test",
       id: nil
     }}
  end
end
