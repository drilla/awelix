defmodule AwelixWeb.PageControllerTest do
  use AwelixWeb.ConnCase, async: false

  describe "system is ready" do
    setup do
      Awelix.Pact.register(:repo, Awelix.Helpers.Mocks.RepoWithData)

      %{conn: build_conn()}
    end

    test "GET /", %{conn: conn} do
      conn = get(conn, "/")

      assert html_response(conn, 200) =~ "Awesome Elixir"
    end

    test "GET / with params", %{conn: conn} do
      conn = get(conn, "/", %{"min_stars" => "12"})
      assert html_response(conn, 200) =~ "Awesome Elixir"
    end

    test "GET / with invalid min_stars param", %{conn: conn} do
      conn = get(conn, "/", %{"min_stars" => "123invalid"})
      assert conn.status == 400
    end
  end

  describe "system is not ready" do
    setup do
      Awelix.Pact.register(:repo, Awelix.Helpers.Mocks.RepoNotReady)
      %{conn: build_conn()}
    end

    test "GET / when system not ready", %{conn: conn} do
      conn = get(conn, "/")
      assert conn.status == 425
    end
  end
end
