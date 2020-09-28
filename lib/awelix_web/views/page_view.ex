defmodule AwelixWeb.PageView do
  alias Awelix.Services.Packages.Category

  use AwelixWeb, :view

  def anchor(%Category{name: name}) do
    name
    |> String.downcase()
    |> String.replace(" ", "-")
  end
end
