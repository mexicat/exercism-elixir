defmodule OCRNumbers do
  @numbers [
    {
      " _ ",
      "| |",
      "|_|",
      "   "
    },
    {
      "   ",
      "  |",
      "  |",
      "   "
    },
    {
      " _ ",
      " _|",
      "|_ ",
      "   "
    },
    {
      " _ ",
      " _|",
      " _|",
      "   "
    },
    {
      "   ",
      "|_|",
      "  |",
      "   "
    },
    {
      " _ ",
      "|_ ",
      " _|",
      "   "
    },
    {
      " _ ",
      "|_ ",
      "|_|",
      "   "
    },
    {
      " _ ",
      "  |",
      "  |",
      "   "
    },
    {
      " _ ",
      "|_|",
      "|_|",
      "   "
    },
    {
      " _ ",
      "|_|",
      " _|",
      "   "
    }
  ]

  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: String.t()
  def convert(input) when rem(length(input), 4) != 0, do: {:error, 'invalid line count'}

  def convert(input) do
    try do
      result =
        input
        |> Enum.chunk_every(4)
        |> Enum.map(&convert_line/1)
        |> Enum.join(",")

      {:ok, result}
    rescue
      e in ArgumentError -> {:error, e.message}
    end
  end

  def convert_line(line) do
    line
    |> Enum.map(fn row ->
      if rem(String.length(row), 3) == 0,
        do: for(<<x::binary-3 <- row>>, do: x),
        else: raise(ArgumentError, message: 'invalid column count')
    end)
    |> Enum.zip()
    |> Enum.reduce("", fn x, acc ->
      case Enum.find_index(@numbers, &(&1 == x)) do
        nil -> "#{acc}?"
        n -> "#{acc}#{n}"
      end
    end)
  end
end
