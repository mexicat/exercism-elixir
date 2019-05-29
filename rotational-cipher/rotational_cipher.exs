defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    text
    |> String.to_charlist()
    |> Enum.map(fn a -> char_shift(a, shift) end)
    |> to_string
  end

  def char_shift(char, shift) when ?a <= char and char <= ?z do
    case char + shift do
      shifted when shifted > ?z -> shifted - 26
      shifted -> shifted
    end
  end

  def char_shift(char, shift) when ?A <= char and char <= ?Z do
    case char + shift do
      shifted when shifted > ?Z -> shifted - 26
      shifted -> shifted
    end
  end

  def char_shift(char, _) do
    char
  end
end
