defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, 1), do: str

  def encode(str, rails) do
    {_, _, output} = do_encode(str, rails)

    output |> List.flatten() |> Enum.join("")
  end

  defp do_encode(str, rails) do
    Enum.reduce(
      String.codepoints(str),
      {1, :down, List.duplicate([], rails)},
      fn x, {i, dir, acc} ->
        new_acc = List.replace_at(acc, i - 1, Enum.at(acc, i - 1) ++ [x])

        case {i, dir} do
          {^rails, :down} -> {i - 1, :up, new_acc}
          {1, :up} -> {i + 1, :down, new_acc}
          {_, :down} -> {i + 1, :down, new_acc}
          {_, :up} -> {i - 1, :up, new_acc}
        end
      end
    )
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, rails) do
    s = String.codepoints(str)
    List.duplicate("?", length(s)) |> do_encode(rails) |> Enum.reduce([], fn x, acc ->
      Enum.reduce(x, s, fn i, )
    end)
  end
end
