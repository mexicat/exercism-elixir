defmodule Tournament do
  @win %{mp: 1, w: 1, d: 0, l: 0, p: 3}
  @draw %{mp: 1, w: 0, d: 1, l: 0, p: 1}
  @loss %{mp: 1, w: 0, d: 0, l: 1, p: 0}
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    input
    |> parse_matches(%{})
    |> Enum.sort_by(
      fn {team, results} ->
        String.first(team)
        results.p
      end,
      &>=/2
    )
    |> List.insert_at(0, {"Team", %{mp: "MP", w: "W", d: "D", l: "L", p: "P"}})
    |> Enum.map(&output_line/1)
    |> Enum.join("\n")
  end

  defp parse_matches([], state), do: state

  defp parse_matches([head | tail], state) do
    parse_matches(tail, head |> String.split(";") |> record_match(state))
  end

  defp record_match([team1, team2, "win"], state) do
    Map.merge(state, %{team1 => @win, team2 => @loss}, &merge_results/3)
  end

  defp record_match([team1, team2, "loss"], state) do
    Map.merge(state, %{team1 => @loss, team2 => @win}, &merge_results/3)
  end

  defp record_match([team1, team2, "draw"], state) do
    Map.merge(state, %{team1 => @draw, team2 => @draw}, &merge_results/3)
  end

  defp record_match(_, state), do: state

  defp merge_results(_, v1, v2) do
    Map.merge(v1, v2, fn _, vv1, vv2 ->
      vv1 + vv2
    end)
  end

  defp output_line({team, results}) do
    [
      String.pad_trailing(team, 30),
      String.pad_leading("#{results.mp}", 2),
      String.pad_leading("#{results.w}", 2),
      String.pad_leading("#{results.d}", 2),
      String.pad_leading("#{results.l}", 2),
      String.pad_leading("#{results.p}", 2)
    ]
    |> Enum.join(" | ")
  end
end
