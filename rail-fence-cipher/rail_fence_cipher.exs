defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, 1), do: str
  def encode("", _), do: ""

  def encode(str, rails) do
    points =
      str
      |> String.length()
      |> make_railway(rails)
      |> Enum.zip(String.codepoints(str))

    for rail <- 1..rails do
      points
      |> Enum.filter(fn {n, _} -> n == rail end)
      |> Enum.map(fn {_, s} -> s end)
    end
    |> List.flatten()
    |> List.to_string()
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, 1), do: str
  def decode("", _), do: ""

  def decode(str, rails) do
    points =
      str
      |> String.length()
      |> make_railway(rails)

    {result, _} =
      str
      |> String.codepoints()
      |> Enum.reduce({points, 1}, &decoder_reducer/2)

    result |> List.to_string()
  end

  defp make_railway(len, rails) do
    {_, _, lines} =
      1..len
      |> Enum.reduce({1, :down, []}, fn
        _, {^rails, :down, acc} -> {rails - 1, :up, [rails | acc]}
        _, {1, :up, acc} -> {1 + 1, :down, [1 | acc]}
        _, {n, :down, acc} -> {n + 1, :down, [n | acc]}
        _, {n, :up, acc} -> {n - 1, :up, [n | acc]}
      end)

    Enum.reverse(lines)
  end

  defp decoder_reducer(char, {acc, railway}) do
    case(acc |> Enum.find_index(&(&1 == railway))) do
      nil -> decoder_reducer(char, {acc, railway + 1})
      index -> {List.replace_at(acc, index, char), railway}
    end
  end
end
