defmodule Awelix.Helpers.Mocks.HttpOkLastCommit do
  def get(_, _, _) do
    {:ok,
     %HTTPoison.Response{
       body: ~s(
       {
         "commit":
         {
           "commit":
           {
             "author":
             {
               "name": "Cory O'Daniel",
               "email": "cory@coryodaniel.com",
               "date": "2020-09-15T09:35:03Z"
             }
           }
         }
       })
     }}
  end
end
