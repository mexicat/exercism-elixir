defmodule Graph do
  defstruct attrs: [], nodes: [], edges: []
end

defmodule Dot do
  defmacro graph(do: ast) do
    %Graph{} |> do_graph(ast) |> Macro.escape()
  end

  defp do_graph(graph, lines) when is_list(lines) do
    Enum.reduce(lines, graph, &do_graph(&2, &1))
  end

  defp do_graph(graph, {:__block__, _, rest}) do
    do_graph(graph, rest)
  end

  defp do_graph(graph, {:graph, _, attrs}) do
    attrs = List.flatten([attrs | graph.attrs])
    if not Keyword.keyword?(attrs), do: raise(ArgumentError)
    do_graph(%{graph | attrs: attrs})
  end

  defp do_graph(graph, {:--, _, [{node1, _, _}, {node2, _, attrs}]}) do
    attrs = List.flatten(attrs || [])
    if not Keyword.keyword?(attrs), do: raise(ArgumentError)
    do_graph(%{graph | edges: [{node1, node2, attrs} | graph.edges]})
  end

  defp do_graph(graph, {node, _, attrs}) when is_atom(node) do
    attrs = List.flatten(attrs || [])
    if not Keyword.keyword?(attrs), do: raise(ArgumentError)
    do_graph(%{graph | nodes: [{node, attrs} | graph.nodes]})
  end

  defp do_graph(_, _) do
    raise ArgumentError
  end

  defp do_graph(graph) do
    %Graph{
      attrs: Enum.sort(graph.attrs),
      nodes: Enum.sort(graph.nodes),
      edges: Enum.sort(graph.edges)
    }
  end
end
