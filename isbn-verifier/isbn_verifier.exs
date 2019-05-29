defmodule ISBNVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> ISBNVerifier.isbn?("3-598-21507-X")
      true

      iex> ISBNVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    cleaned = isbn |> String.replace(~r/\W/, "")

    if String.match?(cleaned, ~r/\d{9}(\d|X)$/),
      do: cleaned |> String.codepoints() |> check,
      else: false
  end

  defp check(list) do
    list
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {x, i}, acc ->
      if x == "X",
        do: 10 + acc,
        else: String.to_integer(x) * i + acc
    end)
    |> rem(11) == 0
  end
end
