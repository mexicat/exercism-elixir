defmodule Scrabble do
  @scores %{
    ["A", "E", "I", "O", "U", "L", "N", "R", "S", "T"] => 1,
    ["D", "G"] => 2,
    ["B", "C", "M", "P"] => 3,
    ["F", "H", "V", "W", "Y"] => 4,
    ["K"] => 5,
    ["J", "X"] => 8,
    ["Q", "Z"] => 10
  }
  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t()) :: non_neg_integer
  def score(word) do
    word |> String.trim() |> String.upcase() |> String.codepoints() |> evaluate
  end

  defp evaluate(_, points \\ 0)

  defp evaluate([], points), do: points

  defp evaluate([head | tail], points) do
    case Enum.find(Map.keys(@scores), :not_found, &Enum.member?(&1, head)) do
      :not_found -> evaluate(tail, points)
      x -> evaluate(tail, points + Map.get(@scores, x))
    end
  end
end
