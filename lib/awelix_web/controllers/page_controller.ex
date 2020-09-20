defmodule AwelixWeb.PageController do
  use AwelixWeb, :controller

  alias Awelix.Services.Packages.Api
  require Awelix.Pact

  plug AwelixWeb.Plugs.ValidateParamIsInteger, :min_stars

  def index(conn, %{"min_stars" => min_stars})  do
    Api.fetch(min_stars)
    |> render_result(conn)
  end

  def index(conn, _params) do
    Api.fetch()
    |> render_result(conn)
  end

  defp render_result({:error, :not_ready_yet}, conn) do
    conn
    |> put_view(AwelixWeb.ErrorView)
    |> put_status(425)
    |> render("425.html")
  end

  defp render_result({:ok, _packages}, conn) do
    render(conn, "index.html")
  end
end
