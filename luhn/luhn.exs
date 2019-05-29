defmodule Luhn do
  require Integer

  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    specialless = String.replace(number, ~r/[^\d]/, "")
    spaceless = String.replace(number, " ", "")

    if spaceless == specialless,
      do: checksum(spaceless),
      else: false
  end

  defp checksum(number) when byte_size(number) < 2, do: false

  defp checksum(number) do
    number
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
    |> Enum.reverse()
    |> Enum.map_every(2, &double/1)
    |> Enum.sum()
    |> rem(10)
    |> Kernel.==(0)
  end

  def double(n) do
    case n * 2 do
      x when x > 9 -> x - 9
      x -> x
    end
  end
end
