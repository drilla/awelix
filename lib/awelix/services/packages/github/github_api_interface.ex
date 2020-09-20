defmodule Awelix.Services.Packages.Github.GithubApiInterface do
  @callback fetch_file(binary(), binary(), binary()) ::
              {:error, HTTPoison.Error.t()}
              | {:ok,
                 %{
                   :__struct__ => HTTPoison.Response,
                   :body => binary()
                 }}

  @callback fetch_repository_info(binary(), binary()) ::
              {:error, HTTPoison.Error.t()}
              | {:ok,
                 %{
                   :__struct__ => HTTPoison.Response,
                   :body => binary()
                 }}
end
