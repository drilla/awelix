defmodule Awelix.Services.Packages.Github.Readme.PackagesExtractorInterface do
  alias Awelix.Services.Packages.Package

  @callback extract(binary()) :: {:ok, [Package.t() | :error]}
end
