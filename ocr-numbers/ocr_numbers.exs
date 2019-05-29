defmodule OCRNumbers do
  @numbers [
    [
      " _ ",
      "| |",
      "|_|",
      "   "
    ],
    [
      "   ",
      "  |",
      "  |",
      "   "
    ],
    [
      " _ ",
      " _|",
      "|_ ",
      "   "
    ],
    [
      " _ ",
      " _|",
      " _|",
      "   "
    ],
    [
      "   ",
      "|_|",
      "  |",
      "   "
    ],
    [
      " _ ",
      "|_ ",
      " _|",
      "   "
    ],
    [
      " _ ",
      "|_ ",
      "|_|",
      "   "
    ],
    [
      " _ ",
      "| |",
      "  |",
      "   "
    ],
    [
      " _ ",
      "|_|",
      "|_|",
      "   "
    ],
    [
      " _ ",
      "|_|",
      " _|",
      "   "
    ]
  ]
  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: String.t()
  def convert(input)
      when rem(length(input), 3) != 0,
      do: {:error, 'invalid line count'}

  def convert([h | _])
      when rem(byte_sizde(h), 3) != 0,
      do: {:error, 'invalid column count'}

  def convert(input) do
    rows = input |> Enum.chunk_every(4)

    for row <- rows, do

    end
  end
end
