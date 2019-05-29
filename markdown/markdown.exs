defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(str) do
    str
    |> parse_inlines
    |> String.split("\n")
    |> Enum.map_join(&parse_encloses/1)
    |> fix_lists
  end

  @doc """
  This function parses inline syntax (i.e., tags that can be embedded in another element).
  More functions can be created and added to this pipeline, which always inputs/outputs a String.
  """
  @spec parse_inlines(String.t()) :: String.t()
  def parse_inlines(str) do
    str
    |> parse_bold
    |> parse_italics
  end

  @doc """
  This function parses top-level syntax, depending on the starting character of the input string,
  and returns an enclosed string (a paragraph by default).
  More functions can be created and added to this case, which always inputs/outputs a String.
  """
  @spec parse_encloses(String.t()) :: String.t()
  def parse_encloses(str) do
    case String.first(str) do
      "*" -> parse_list(str)
      "#" -> parse_header(str)
      _ -> "<p>#{str}</p>"
    end
  end

  @spec parse_bold(String.t()) :: String.t()
  defp parse_bold(str) do
    String.replace(str, ~r/__(.*?)__/, "<strong>\\1</strong>")
  end

  @spec parse_italics(String.t()) :: String.t()
  defp parse_italics(str) do
    String.replace(str, ~r/_(.*?)_/, "<em>\\1</em>")
  end

  @spec parse_list(String.t()) :: String.t()
  defp parse_list(str) do
    String.replace(str, ~r/^\* (.*)/, "<ul><li>\\1</li></ul>")
  end

  @spec parse_header(String.t()) :: String.t()
  defp parse_header(str) do
    trimmed = String.trim_leading(str, "#")
    # heading number
    n = String.length(str) - String.length(trimmed)

    "<h#{n}>#{String.trim(trimmed)}</h#{n}>"
  end

  @spec fix_lists(String.t()) :: String.t()
  defp fix_lists(str) do
    String.replace(str, "</ul><ul>", "")
  end
end
