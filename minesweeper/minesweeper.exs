defmodule Minesweeper do
  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]

  def annotate(board) do
    board
    |> Enum.map(&String.codepoints/1)
    |> do_annotate
  end

  defp do_annotate(board, prev \\ [], acc \\ [])

  defp do_annotate([current, next | rest], prev, acc) do
    do_annotate([next | rest], current, [find_mines(current, prev, next) | acc])
  end

  defp do_annotate([current | rest], prev, acc) do
    do_annotate(rest, current, [find_mines(current, prev, []) | acc])
  end

  defp do_annotate([], _, acc) do
    acc
    |> Enum.reverse()
    |> Enum.map(fn x ->
      x |> to_string() |> String.replace("0", " ")
    end)
  end

  defp find_mines(current, prev, next) do
    for {col, i} <- Enum.with_index(current) do
      case col do
        " " ->
          min_range = if i == 0, do: 0, else: i - 1
          max_range = i + 1

          for index <- min_range..max_range,
              row <- [current, prev, next],
              Enum.at(row, index) == "*" do
            true
          end
          |> Enum.count()
          |> Integer.to_string()

        x ->
          x
      end
    end
  end
end
