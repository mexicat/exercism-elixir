defmodule BinTree do
  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """

  @type t :: %BinTree{value: any, left: t() | nil, right: t() | nil}
  defstruct [:value, :left, :right]
end

defimpl Inspect, for: BinTree do
  import Inspect.Algebra

  # A custom inspect instance purely for the tests, this makes error messages
  # much more readable.
  #
  # BinTree[value: 3, left: BinTree[value: 5, right: BinTree[value: 6]]] becomes (3:(5::(6::)):)
  def inspect(%BinTree{value: value, left: left, right: right}, opts) do
    concat([
      "(",
      to_doc(value, opts),
      ":",
      if(left, do: to_doc(left, opts), else: ""),
      ":",
      if(right, do: to_doc(right, opts), else: ""),
      ")"
    ])
  end
end

defmodule Zipper do
  @type trail :: nil | {:left | :right, BinTree.t()}
  @type t :: %Zipper{current: BinTree.t(), trail: trail}
  defstruct [:current, :trail]

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree) do
    %Zipper{current: bin_tree, trail: []}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%Zipper{current: current, trail: []}), do: current

  def to_tree(%Zipper{trail: [{_, parent} | trail]}) do
    to_tree(%Zipper{current: parent, trail: trail})
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(%Zipper{current: %{value: value}}), do: value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%Zipper{current: %{left: nil}}), do: nil

  def left(%Zipper{current: current, trail: trail}) do
    %Zipper{current: current.left, trail: [{:left, current} | trail]}
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%Zipper{current: %{right: nil}}), do: nil

  def right(%Zipper{current: current, trail: trail}) do
    %Zipper{current: current.right, trail: [{:right, current} | trail]}
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%Zipper{trail: []}), do: nil

  def up(%Zipper{trail: [{_, tree} | trail]}) do
    %Zipper{current: tree, trail: trail}
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(%Zipper{current: current, trail: trail}, value) do
    updated = %{current | value: value}
    %Zipper{current: updated, trail: update_trail(trail, updated)}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(%Zipper{current: current, trail: trail}, left) do
    updated = %{current | left: left}
    %Zipper{current: updated, trail: update_trail(trail, updated)}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(%Zipper{current: current, trail: trail}, right) do
    updated = %{current | right: right}
    %Zipper{current: updated, trail: update_trail(trail, updated)}
  end

  defp update_trail(trail, new, acc \\ [])

  defp update_trail([], _, acc) do
    Enum.reverse(acc)
  end

  defp update_trail([{dir, tree} | tail], new, acc) do
    updated = Map.put(tree, dir, new)
    update_trail(tail, updated, [{dir, updated} | acc])
  end
end
