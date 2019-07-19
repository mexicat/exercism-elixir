defmodule Card do
  defstruct [:n, :s]

  @figures ~w{J Q K A}
  @figvalues [11, 12, 13, 14]
  @figmap Enum.zip(@figures, @figvalues) |> Enum.into(%{})
  @valmap Enum.zip(@figvalues, @figures) |> Enum.into(%{})

  def from_string(str) do
    str
    |> String.split_at(-1)
    |> case do
      {n, s} when n in @figures -> %Card{n: @figmap[n], s: s}
      {n, s} -> %Card{n: String.to_integer(n), s: s}
    end
  end

  def to_string(%Card{n: n, s: s}) do
    n =
      case n do
        n when n in @figvalues -> @valmap[n]
        n when n == 1 -> "A"
        n -> n
      end

    "#{n}#{s}"
  end
end

defmodule Hand do
  defguardp is_straight(a, b, c, d, e)
            when a - 1 == b and b - 1 == c and c - 1 == d and d - 1 == e

  defstruct [:score, :cards, :ordered]

  def from_list(list) do
    list |> Enum.map(&Card.from_string/1) |> score_hand
  end

  def to_list(%Hand{cards: cards}) do
    cards |> Enum.map(&Card.to_string/1)
  end

  defp sort(cards) do
    cards
    |> Enum.sort_by(
      fn card -> {Enum.count(cards, &(card.n == &1.n)), card.n} end,
      &>=/2
    )
    |> check_min_straight
  end

  defp check_min_straight([
         %Card{n: 14} = c1,
         %Card{n: 5} = c2,
         %Card{n: 4} = c3,
         %Card{n: 3} = c4,
         %Card{n: 2} = c5
       ]),
       do: [c2, c3, c4, c5, %{c1 | n: 1}]

  defp check_min_straight(cards), do: cards

  defp score_hand(cards) do
    {score, ordered} =
      cards |> sort |> has_straight_flush? ||
        cards |> sort |> has_four_of_a_kind? ||
        cards |> sort |> has_full_house? ||
        cards |> has_flush? ||
        cards |> sort |> has_straight? ||
        cards |> sort |> has_three_of_a_kind? ||
        cards |> sort |> has_two_pair? ||
        cards |> sort |> has_one_pair? ||
        {:high_card, cards |> sort}

    %Hand{score: score, cards: cards, ordered: ordered}
  end

  defp has_straight_flush?(
         [
           %Card{n: a, s: s},
           %Card{n: b, s: s},
           %Card{n: c, s: s},
           %Card{n: d, s: s},
           %Card{n: e, s: s}
         ] = cards
       )
       when is_straight(a, b, c, d, e),
       do: {:straight_flush, cards}

  defp has_straight_flush?(_), do: false

  defp has_four_of_a_kind?(
         [
           %Card{n: a},
           %Card{n: a},
           %Card{n: a},
           %Card{n: a},
           %Card{}
         ] = cards
       ),
       do: {:four_of_a_kind, cards}

  defp has_four_of_a_kind?(_), do: false

  defp has_full_house?(
         [
           %Card{n: a},
           %Card{n: a},
           %Card{n: a},
           %Card{n: b},
           %Card{n: b}
         ] = cards
       ),
       do: {:full_house, cards}

  defp has_full_house?(_), do: false

  defp has_flush?(
         [
           %Card{s: s},
           %Card{s: s},
           %Card{s: s},
           %Card{s: s},
           %Card{s: s}
         ] = cards
       ),
       do: {:flush, cards}

  defp has_flush?(_), do: false

  defp has_straight?(
         [
           %Card{n: a},
           %Card{n: b},
           %Card{n: c},
           %Card{n: d},
           %Card{n: e}
         ] = cards
       )
       when is_straight(a, b, c, d, e),
       do: {:straight, cards}

  defp has_straight?(_), do: false

  defp has_three_of_a_kind?(
         [
           %Card{n: a},
           %Card{n: a},
           %Card{n: a},
           %Card{},
           %Card{}
         ] = cards
       ),
       do: {:three_of_a_kind, cards}

  defp has_three_of_a_kind?(_), do: false

  defp has_two_pair?(
         [
           %Card{n: a},
           %Card{n: a},
           %Card{n: b},
           %Card{n: b},
           %Card{}
         ] = cards
       ),
       do: {:two_pair, cards}

  defp has_two_pair?(_), do: false

  defp has_one_pair?(
         [
           %Card{n: a},
           %Card{n: a},
           %Card{},
           %Card{},
           %Card{}
         ] = cards
       ),
       do: {:one_pair, cards}

  defp has_one_pair?(_), do: false
end

defmodule Poker do
  @scores %{
    high_card: 0,
    one_pair: 1,
    two_pair: 2,
    three_of_a_kind: 3,
    straight: 4,
    flush: 5,
    full_house: 6,
    four_of_a_kind: 7,
    straight_flush: 8
  }

  @spec best_hand(list(list(String.t()))) :: list(list(String.t()))
  def best_hand(hands) do
    sorted_hands =
      hands
      |> Enum.map(&Hand.from_list/1)
      |> Enum.sort_by(
        &{@scores[&1.score], Enum.map(&1.ordered, fn %Card{n: n} -> n end)},
        &>=/2
      )

    best = sorted_hands |> List.first()

    sorted_hands
    |> Enum.filter(fn hand -> same_values?(best, hand) end)
    |> Enum.map(&Hand.to_list/1)
  end

  defp same_values?(
         %Hand{
           cards: [%Card{n: n1}, %Card{n: n2}, %Card{n: n3}, %Card{n: n4}, %Card{n: n5}]
         },
         %Hand{
           cards: [%Card{n: n1}, %Card{n: n2}, %Card{n: n3}, %Card{n: n4}, %Card{n: n5}]
         }
       ),
       do: true

  defp same_values?(_, _), do: false
end
