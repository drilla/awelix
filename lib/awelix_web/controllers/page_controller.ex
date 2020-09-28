defmodule AwelixWeb.PageController do
  use AwelixWeb, :controller

  alias Awelix.Services.Packages.Api
  require Awelix.Pact

  plug AwelixWeb.Plugs.ValidateParamIsInteger, :min_stars

  def index(conn, %{"min_stars" => min_stars})  do
    Api.fetch_categories(min_stars |> String.to_integer())
    |> render_result(conn)
  end

  def index(conn, _params) do
    Api.fetch_categories(nil)
    |> render_result(conn)
  end

  defp render_result({:error, :not_ready_yet}, conn) do
    conn
    |> put_view(AwelixWeb.ErrorView)
    |> put_status(425)
    |> render("425.html")
  end

  defp render_result({:ok, categories}, conn) do
    conn
    |> assign(:categories, categories)
    |> render("index.html")
  end
end
