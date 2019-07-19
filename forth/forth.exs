defmodule Forth do
  @opaque evaluator :: %Forth{}
  defstruct stack: [], subs: %{}

  @kwregex ~r/: (?<word>.+?) (?<subs>.+?) ;/

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new(), do: %Forth{}

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(%Forth{subs: subs}, s) do
    subs =
      for [word, sub] <- Regex.scan(@kwregex, s, capture: :all_but_first),
          into: subs do
        case(Integer.parse(word)) do
          :error -> {word, sub}
          {w, _} -> raise Forth.InvalidWord, word: w
        end
      end

    stack =
      s
      |> String.replace(@kwregex, "")
      |> String.split(~r/[\p{Z}|\p{C}]+/u, trim: true)
      |> Enum.map(fn x ->
        if x in Map.keys(subs),
          do: String.split(subs[x], " ", trim: true),
          else: x
      end)
      |> List.flatten()
      |> do_eval

    %Forth{stack: stack, subs: subs}
  end

  defp do_eval(s, acc \\ [])

  defp do_eval(s, ["+", b, a | acc]), do: do_eval(s, [a + b | acc])

  defp do_eval(s, ["-", b, a | acc]), do: do_eval(s, [a - b | acc])

  defp do_eval(s, ["*", b, a | acc]), do: do_eval(s, [a * b | acc])

  defp do_eval(_, ["/", 0 | _]), do: raise(Forth.DivisionByZero)
  defp do_eval(s, ["/", b, a | acc]), do: do_eval(s, [Integer.floor_div(a, b) | acc])

  defp do_eval(s, ["dup", a | acc]), do: do_eval(s, [a, a | acc])
  defp do_eval(_, ["dup" | _]), do: raise(Forth.StackUnderflow)

  defp do_eval(s, ["drop", _ | acc]), do: do_eval(s, acc)
  defp do_eval(_, ["drop" | _]), do: raise(Forth.StackUnderflow)

  defp do_eval(s, ["swap", b, a | acc]), do: do_eval(s, [a, b | acc])
  defp do_eval(_, ["swap" | _]), do: raise(Forth.StackUnderflow)

  defp do_eval(s, ["over", b, a | acc]), do: do_eval(s, [a, b, a | acc])
  defp do_eval(_, ["over" | _]), do: raise(Forth.StackUnderflow)

  defp do_eval(_, [w | _]) when not is_integer(w), do: raise(Forth.UnknownWord, word: w)

  defp do_eval([h | t], acc) do
    case Integer.parse(h) do
      :error -> do_eval(t, [String.downcase(h) | acc])
      {n, _} -> do_eval(t, [n | acc])
    end
  end

  defp do_eval([], acc), do: Enum.reverse(acc)

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(%Forth{stack: stack}) do
    Enum.join(stack, " ")
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
