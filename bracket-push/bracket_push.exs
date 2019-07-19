defmodule BracketPush do
  @openers ~w/{ [ (/
  @closers ~w/} ] )/
  @matches Enum.zip(@closers, @openers) |> Enum.into(%{})

  defguardp is_opener(val) when val in @openers
  defguardp is_closer(val) when val in @closers

  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    str
    |> String.codepoints()
    |> do_check_brackets([])
  end

  defp do_check_brackets([head | tail], acc) when is_opener(head) do
    do_check_brackets(tail, [head | acc])
  end

  defp do_check_brackets([head | tail], [acc_head | acc_rest]) when is_closer(head) do
    if acc_head == @matches[head], do: do_check_brackets(tail, acc_rest), else: false
  end

  defp do_check_brackets([_ | tail], acc) do
    do_check_brackets(tail, acc)
  end

  defp do_check_brackets([], []), do: true
  defp do_check_brackets(_, _), do: false
end
