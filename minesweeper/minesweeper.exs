defmodule Minesweeper do
  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]

  def annotate(board) do
    Enum.map(board, &String.replace(&1, ~r/[^*]/, " "))
  end
end
