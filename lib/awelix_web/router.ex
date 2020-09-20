defmodule AwelixWeb.Router do
  use AwelixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :put_secure_browser_headers
  end

  scope "/", AwelixWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", AwelixWeb do
  #   pipe_through :api
  # end
end
