defmodule Awelix.Helpers.Mocks.HttpOkBodyCorrupt do
  def get(_, _) do{:ok,
     %HTTPoison.Response{
       body: ~s(:bogus content:})
     }}
  end
end
