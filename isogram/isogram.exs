defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    list = sentence |> String.replace(~r/[^A-Za-z]/, "") |> String.graphemes()

    MapSet.new(list) |> MapSet.size() == length(list)
  end
end
