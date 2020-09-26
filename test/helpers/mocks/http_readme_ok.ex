defmodule Awelix.Helpers.Mocks.HttpReadmeOk do
  def get(_, _, _ \\ []) do{:ok,
     %HTTPoison.Response{
       # MTIzNDU2 means 123456
       body: "{\"content\":\"MTIzNDU2\"}"
     }}
  end
end
