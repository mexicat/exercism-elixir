defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """
  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @weekday_mapping %{
    :monday => 1,
    :tuesday => 2,
    :wednesday => 3,
    :thursday => 4,
    :friday => 5,
    :saturday => 6,
    :sunday => 7
  }

  @schedule_mapping %{
    :first => 0,
    :second => 1,
    :third => 2,
    :fourth => 3,
    :last => -1
  }

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date()
  def meetup(year, month, weekday, :teenth) do
    day =
      Enum.find(13..19, fn x ->
        Calendar.ISO.day_of_week(year, month, x) == @weekday_mapping[weekday]
      end)

    {year, month, day}
  end

  def meetup(year, month, weekday, schedule) do
    day =
      1..Calendar.ISO.days_in_month(year, month)
      |> Enum.filter(fn x ->
        Calendar.ISO.day_of_week(year, month, x) == @weekday_mapping[weekday]
      end)
      |> Enum.at(@schedule_mapping[schedule])

    {year, month, day}
  end
end
