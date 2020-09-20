defmodule Awelix.Helpers.Mocks.GithubApiReadmeOk do
  @behaviour Awelix.Services.Packages.Github.GithubApiInterface

  @impl true
  def fetch_file(_, _, _) do
    {:ok,
     %HTTPoison.Response{
       # MTIzNDU2 means 123456
       body: "{\"sha\":\"123456\",\"content\":\"MTIzNDU2\"}"
     }}
  end

  @impl true
  def fetch_repository_info(binary, binary) do
    nil
  end

end
