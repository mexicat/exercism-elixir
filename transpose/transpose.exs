defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples
  iex> Transpose.transpose("ABC\nDE")
  "AD\nBE\nC"

  iex> Transpose.transpose("AB\nDEF")
  "AD\nBE\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(""), do: ""

  def transpose(input) do
    rows = String.split(input, "\n")
    longest = rows |> Enum.max_by(&String.length(&1)) |> String.length()

    rows
    |> Enum.map(&(&1 |> String.pad_trailing(longest) |> String.codepoints()))
    |> Enum.zip()
    |> Enum.map_join("\n", &(&1 |> Tuple.to_list() |> Enum.join()))
    |> String.trim()
  end
end
