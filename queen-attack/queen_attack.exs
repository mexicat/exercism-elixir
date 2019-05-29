defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct [:black, :white]

  @doc """
  Creates a new set of Queens
  """
  @spec new() :: Queens.t()
  @spec new({integer, integer}, {integer, integer}) :: Queens.t()
  def new(white \\ {0, 3}, black \\ {7, 3})
  def new(x, x), do: raise(ArgumentError)

  def new(w, b) do
    %Queens{white: w, black: b}
  end

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(%Queens{black: {bx, by}, white: {wx, wy}}) do
    Enum.map_join(0..7, "\n", fn
      ^bx when bx == wx ->
        empty_row() |> List.replace_at(by, "B") |> List.replace_at(wy, "W") |> Enum.join(" ")

      ^bx ->
        empty_row() |> List.replace_at(by, "B") |> Enum.join(" ")

      ^wx ->
        empty_row() |> List.replace_at(wy, "W") |> Enum.join(" ")

      _ ->
        empty_row() |> Enum.join(" ")
    end)
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%Queens{black: {bx, by}, white: {wx, wy}})
      when bx == wx or by == wy
      when abs(bx - by) == abs(wx - wy),
      do: true

  def can_attack?(_), do: false

  defp empty_row(), do: List.duplicate("_", 8)
end
