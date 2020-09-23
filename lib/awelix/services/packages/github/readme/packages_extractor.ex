defmodule Awelix.Services.Packages.Github.Readme.PackagesExtractor do
  alias Awelix.Services.Packages.Package

  require Logger

  @behaviour Awelix.Services.Packages.Github.Readme.PackagesExtractorInterface

  # This is how a line has to look like.
  @line_regex ~r/^\[([^]]+)\]\(([^)]+)\) - (.+)([\.\!]+)$/
  @url_regex ~r/^https\:\/\/github.com\/(.+)\/(.+)$/

  @recources_caption "Resources"

  @impl true
  def extract(content) do
    {blocks, _conext} = EarmarkParser.Parser.parse_markdown(content)

    result =
      blocks
      |> drop_heading()
      |> drop_recources()
      |> Enum.chunk_every(3)
      |> Enum.map(&parse_category(&1))
      |> List.flatten()

    {:ok, result}
  end

  # drop headings
  defp drop_heading(blocks), do: Enum.drop(blocks, 5)

  defp drop_recources(blocks) do
    blocks
    |> Enum.reverse()
    |> Enum.drop_while(&block_is_not_resource_heading?(&1))
    # drop recource heading self
    |> Enum.drop(1)
    |> Enum.reverse()
  end

  defp block_is_not_resource_heading?(%EarmarkParser.Block.Heading{content: caption}) do
    @recources_caption != caption
  end

  defp block_is_not_resource_heading?(_), do: true

  defp parse_category([
         %EarmarkParser.Block.Heading{content: category},
         %EarmarkParser.Block.Para{lines: desc},
         %EarmarkParser.Block.List{blocks: items}
       ]) do
    items
    |> Enum.map(&parse_item(&1))
    |> Enum.filter(fn item -> item != :error end)
    |> Enum.map(&Map.put(&1, :category_desc, Enum.join(desc)))
    |> Enum.map(&Map.put(&1, :category, category))
  end

  defp parse_item(%EarmarkParser.Block.ListItem{
         blocks: [
           %EarmarkParser.Block.Text{
             # ["[bpe](https://github.com/spawnproc/bpe) - Business Process Engine in Erlang. ([Doc](https://bpe.n2o.space))."],
             line: [text]
           }
         ]
       }) do
    with {url, name, desc} <- parse_line(text),
         {owner, repo} <- parse_repo_url(url) do
      %Package{
        name: name,
        url: url,
        desc: desc,
        owner: owner,
        repo: repo
      }
    else
      _ ->
        Logger.info(text)
        :error
    end
  end

  defp parse_line(line) do
    case Regex.run(@line_regex, line) do
      nil -> raise("Line does not match format: '#{line}' Is there a dot at the end?")
      [^line, name, url, description, _dot] -> {url, name, description}
    end
  end

  @spec parse_repo_url(binary) :: {binary(), binary()} | :error
  defp parse_repo_url(url) do
    case Regex.run(@url_regex, url) do
      [_url, owner, repo] -> {owner, repo}
      nil -> :error
    end
  end
end
