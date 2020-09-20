defmodule AwelixWeb.Plugs.ValidateParamIsInteger do
  import Plug.Conn
  import Phoenix.Controller, only: [render: 2, put_view: 2]

  @validator ~r/\A\d+\z/

  def init(param_name) when is_atom(param_name), do: param_name

  def call(%Plug.Conn{params: params} = conn, param_name) do
    case Map.get(params, param_name |> Atom.to_string()) do
      nil ->
        conn

      value ->
        if is_integer?(value) do
          conn
        else
          conn
          |> put_status(400)
          |> put_view(AwelixWeb.ErrorView)
          |> render("400.html")
          |> halt()
        end
    end
  end

  defp is_integer?(value) do
    Regex.match?(@validator, value)
  end
end
