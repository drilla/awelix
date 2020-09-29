defmodule AwelixWeb.PageView do
  alias Awelix.Services.Packages.Category

  use AwelixWeb, :view

  def anchor(%Category{name: name}) do
    name
    |> String.downcase()
    |> String.replace(" ", "-")
  end

  def days(%DateTime{} = dt) do
    Timex.diff(Timex.now(), dt, :days)
  end

  def gray?(dt) do
    if days(dt) >= 500 do
    "gray"
  else
    ""
  end
end
end
