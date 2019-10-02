defmodule Palindromes do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1) do
    # iterate through the permutations
    for x <- min_factor..max_factor,
        y <- min_factor..max_factor,
        palindrome?(x * y) do
      # make it a keyword list (sort of).
      # sort the factors list so we can clean up duplicates later
      {x * y, Enum.sort([x, y])}
    end
    # remove duplicate entries
    |> Enum.uniq()
    # group separate entries with the same key in a map
    |> Enum.group_by(fn {k, _} -> k end, fn {_, v} -> v end)
  end

  defp palindrome?(n) do
    str_n = to_string(n)

    str_n == String.reverse(str_n)
  end
end
