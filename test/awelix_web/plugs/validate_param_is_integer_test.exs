defmodule AwelixWeb.Plugs.ValidateParamIsIntegerTest do
  use AwelixWeb.ConnCase
  alias AwelixWeb.Plugs.ValidateParamIsInteger, as: Plug

  test "bypass correct value" do
    conn =
      build_conn("GET", "/", %{"test_param" => "11"})
      |> Plug.call(:test_param)

    refute conn.halted

    assert conn.status == nil
  end

  test "bypass no value value", %{conn: conn} do
    conn =
      conn
      |> Plug.call(:test_param)

    refute conn.halted

    assert conn.status == nil
  end

  test "400 on incorrect value" do
    conn =
      build_conn("GET", "/", test_param: "123invalid")
      |> Plug.call(:test_param)

    assert conn.halted

    assert conn.status == 400
  end
end
