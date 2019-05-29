defmodule Bowling do
  defstruct [:rolls, :frame, :mult, :score]
  @last_frame 10
  @max_roll 10

  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """
  @spec start() :: any
  def start do
    %Bowling{rolls: [], frame: 1, mult: {1, 1}, score: 0}
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """
  @spec roll(any, integer) :: any | String.t()
  def roll(_, roll) when roll < 0, do: {:error, "Negative roll is invalid"}
  def roll(_, roll) when roll > @max_roll, do: {:error, "Pin count exceeds pins on the lane"}
  def roll(%Bowling{frame: :finished}, _), do: {:error, "Cannot roll after game is over"}

  def roll(%Bowling{rolls: rolls} = game, roll) do
    %{game | rolls: [roll | rolls]} |> process
  end

  defp process(%Bowling{rolls: [a | nil], frame: :finished, score: score}) do
    %Bowling{frame: :finished, score: score + a}
  end

  defp process(%Bowling{
         rolls: [c, @max_roll, @max_roll],
         frame: @last_frame,
         mult: {m1, m2},
         score: score
       }) do
    %Bowling{frame: :finished, score: score + @max_roll * m1 + @max_roll * m2 + c}
  end

  defp process(%Bowling{rolls: [c, b, @max_roll], frame: @last_frame})
       when c + b > @max_roll and c + b < @max_roll * 2,
       do: {:error, "Pin count exceeds pins on the lane"}

  defp process(%Bowling{rolls: [c, b, a], frame: @last_frame, mult: {m1, m2}, score: score}) do
    %Bowling{frame: :finished, score: score + a * m1 + b * m2 + c}
  end

  defp process(%Bowling{rolls: [b, a], frame: @last_frame} = game) when b + a >= @max_roll,
    do: game

  defp process(%Bowling{rolls: [b, a], frame: @last_frame, mult: {m1, m2}, score: score}) do
    %Bowling{frame: :finished, score: score + a * m1 + b * m2}
  end

  defp process(%Bowling{rolls: [@max_roll], frame: frame, mult: {m1, m2}, score: score})
       when frame < @last_frame do
    %Bowling{rolls: [], frame: frame + 1, mult: {m2 + 1, 2}, score: score + @max_roll * m1}
  end

  defp process(%Bowling{rolls: [b, a]}) when a + b > @max_roll,
    do: {:error, "Pin count exceeds pins on the lane"}

  defp process(%Bowling{rolls: [b, a], frame: frame, mult: {m1, m2}, score: score})
       when a + b == @max_roll do
    %Bowling{rolls: [], frame: frame + 1, mult: {2, 1}, score: score + a * m1 + b * m2}
  end

  defp process(%Bowling{rolls: [b, a], frame: frame, mult: {m1, m2}, score: score}) do
    %Bowling{rolls: [], frame: frame + 1, mult: {1, 1}, score: score + a * m1 + b * m2}
  end

  defp process(%Bowling{rolls: [_]} = game), do: game

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """
  @spec score(any) :: integer | String.t()
  def score(%Bowling{frame: :finished, score: score}), do: score
  def score(_), do: {:error, "Score cannot be taken until the end of the game"}
end
