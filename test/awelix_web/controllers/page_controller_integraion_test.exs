defmodule AwelixWeb.PageControllerIntegrationTest do
  use AwelixWeb.ConnCase, async: false

  @moduletag :integration

  alias Awelix.Services.Repo.RepoUpdater

  setup do
    RepoUpdater.update_async()
    Process.sleep(5_000)

    %{conn: build_conn()}
  end

  describe "system is ready" do

    test "GET /", %{conn: conn} do
      conn = get(conn, "/")

      resp = html_response(conn, 200)
      assert resp =~ "Awesome Elixir"
      assert resp =~ "Contents"
      assert resp =~ "Actors"
    end

    test "GET / with params", %{conn: conn} do
      conn = get(conn, "/", %{"min_stars" => "12"})

      resp = html_response(conn, 200)
      assert resp =~ "Awesome Elixir"
      assert resp =~ "Contents"
      assert resp =~ "Actors"
    end
  end
end
