defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    string
    |> String.codepoints()
    |> encode_
  end

  defp encode_(string, acc \\ ["", 1, ""])

  defp encode_([a], [amount, acc]) do
    "#{acc}#{calc_amount(a, amount)}"
  end

  defp encode_([a, a | tail], [amount, acc]) do
    encode_([a | tail], [amount + 1, acc])
  end

  defp encode_([a, b | tail], [amount, acc]) do
    case amount do
      0 -> encode_(tail, [head, amount + 1, acc])
      _ -> encode_(tail, [head, 1, "#{acc}#{calc_amount(current_letter, amount)}"])
    end
  end

  defp calc_amount(letter, amount) do
    case amount do
      0 -> ""
      1 -> letter
      _ -> "#{amount}#{letter}"
    end
  end

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    string
    |> String.split(~r{\d+|\D}, trim: true, include_captures: true)
    |> Enum.map(fn x ->
      case Integer.parse(x) do
        :error -> x
        {num, _} -> num
      end
    end)
    |> decode_
  end

  defp decode_(_, _ \\ [1, ""])

  defp decode_([], [_, acc]), do: acc

  defp decode_([head | tail], [_, acc]) when is_number(head) do
    decode_(tail, [head, acc])
  end

  defp decode_([head | tail], [num, acc]) when not is_number(head) do
    decode_(tail, [1, acc <> String.duplicate(head, num)])
  end
end
