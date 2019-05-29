defmodule RobotSimulator do
  defguardp is_valid_direction(direction) when direction in [:north, :east, :south, :west]
  defguardp is_valid_position(x, y) when is_number(x) and is_number(y)

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, _) when not is_valid_direction(direction) do
    {:error, "invalid direction"}
  end

  def create(direction, {x, y}) when is_valid_position(x, y) do
    %{direction: direction, position: {x, y}}
  end

  def create(_, _) do
    {:error, "invalid position"}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    do_simulate(robot, String.codepoints(instructions))
  end

  defp do_simulate(robot, ["R" | tail]) do
    new_direction =
      case robot.direction do
        :north -> :east
        :east -> :south
        :south -> :west
        :west -> :north
      end

    do_simulate(%{robot | direction: new_direction}, tail)
  end

  defp do_simulate(robot, ["L" | tail]) do
    new_direction =
      case robot.direction do
        :north -> :west
        :east -> :north
        :south -> :east
        :west -> :south
      end

    do_simulate(%{robot | direction: new_direction}, tail)
  end

  defp do_simulate(%{position: {x, y}} = robot, ["A" | tail]) do
    new_position =
      case robot.direction do
        :north -> {x, y + 1}
        :east -> {x + 1, y}
        :south -> {x, y - 1}
        :west -> {x - 1, y}
      end

    do_simulate(%{robot | position: new_position}, tail)
  end

  defp do_simulate(robot, []), do: robot

  defp do_simulate(_, _) do
    {:error, "invalid instruction"}
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(%{direction: dir}), do: dir

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(%{position: pos}), do: pos
end
