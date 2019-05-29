defmodule AllYourBase do
  @doc """
  Given a number in base a, represented as a sequence of digits, converts it to base b,
  or returns nil if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: list
  def convert(digits, base_a, base_b)
      when length(digits) == 0
      when base_a < 2
      when base_b < 2,
      do: nil

  def convert(digits, x, x), do: digits

  def convert(digits, base_a, 10) do
    digits
    |> Enum.zip((length(digits) - 1)..0)
    |> Enum.reduce(0, fn {n, i}, acc ->
      round(:math.pow(n, i)) + acc
    end)
    |> Integer.digits()
  end

  def convert(digits, 10, base_b) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while(0, fn x, acc ->
      nil
    end)
  end
end
