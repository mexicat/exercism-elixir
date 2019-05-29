defmodule Roman do
  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t()
  def numerals(number) do
    convert(number)
  end

  defp convert(number, current \\ "") do
    case number do
      n when n >= 1000 -> convert(n - 1000, current <> "M")
      n when n >= 900 -> convert(n - 900, current <> "CM")
      n when n >= 500 -> convert(n - 500, current <> "D")
      n when n >= 400 -> convert(n - 400, current <> "CD")
      n when n >= 100 -> convert(n - 100, current <> "C")
      n when n >= 90 -> convert(n - 90, current <> "XC")
      n when n >= 50 -> convert(n - 50, current <> "L")
      n when n >= 40 -> convert(n - 40, current <> "XL")
      n when n >= 10 -> convert(n - 10, current <> "X")
      n when n >= 9 -> convert(n - 9, current <> "IX")
      n when n >= 5 -> convert(n - 5, current <> "V")
      n when n >= 4 -> convert(n - 4, current <> "IV")
      n when n >= 1 -> convert(n - 1, current <> "I")
      0 -> current
    end
  end
end
