defmodule Grains do
  @range 1..64

  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(number) when number in @range do
    {:ok, do_square(number)}
  end

  def square(_) do
    {:error, "The requested square must be between 1 and 64 (inclusive)"}
  end

  def do_square(n) do
    round(:math.pow(2, n - 1))
  end

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total do
    {:ok, Enum.reduce(@range, 0, &(do_square(&1) + &2))}
  end
end
