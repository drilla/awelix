defmodule Awelix.Services.Github.Readme.PackageExtractorTest do
  use ExUnit.Case

  require Awelix.Pact

  # counted it all night long!
  # общее число 1292, но валидных - 1268, остальные не от гитхаба
  @static_readme_packages_count 1268

  alias Awelix.Services.Github.Readme.PackagesExtractor

  describe "extract packages" do
    setup do
      content = File.read!(__DIR__ <> "/README.md")
      %{content: content}
    end

    test "success", %{content: content} do
      assert {:ok, packages} = PackagesExtractor.extract(content)
      assert is_list(packages)

      assert Enum.count(packages) == @static_readme_packages_count
    end
  end

  describe "extract failed" do
    test "content is bogus" do
      result = PackagesExtractor.extract("boguscontent")
      assert {:ok, []} = result
    end
  end
end
