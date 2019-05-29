defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l, acc \\ 0)
  def count([], acc), do: acc
  def count([_ | t], acc), do: count(t, acc + 1)

  @spec reverse(list) :: list
  def reverse(l, acc \\ [])
  def reverse([], acc), do: acc
  def reverse([h | t], acc), do: reverse(t, [h | acc])

  @spec map(list, (any -> any)) :: list
  def map(l, f, acc \\ [])
  def map([], _, acc), do: reverse(acc)
  def map([h | t], f, acc), do: map(t, f, [f.(h) | acc])

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f, acc \\ [])
  def filter([], _, acc), do: reverse(acc)

  def filter([h | t], f, acc) do
    case f.(h) do
      true -> filter(t, f, [h | acc])
      false -> filter(t, f, acc)
    end
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _), do: acc
  def reduce([h | t], acc, f), do: reduce(t, f.(h, acc), f)

  @spec append(list, list) :: list
  def append(a, b), do: do_append(reverse(a), b)
  def do_append([], b), do: b
  def do_append([h | t], b), do: do_append(t, [h | b])

  @spec concat([[any]]) :: [any]
  def concat(ll), do: do_concat(reverse(ll), [])
  def do_concat([], acc), do: acc
  def do_concat([h | t], acc), do: do_concat(t, append(h, acc))
end
