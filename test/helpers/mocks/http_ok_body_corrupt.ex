defmodule Awelix.Helpers.Mocks.HttpOkBodyCorrupt do
  def post(_, _, _, _) do{:ok,
     %HTTPoison.Response{
       body: ~s(:bogus content:})
     }}
  end
end
