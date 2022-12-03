defmodule Day3 do
  def parse(lines) do
    Enum.map(lines, &parse_line/1)
  end

  def find_badges(sacks) do
    sacks
    |> Enum.chunk_every(3)
    |> Enum.map(&detect_badge/1)
  end

  @spec common_items(list) :: list(String.t)
  def common_items(sacks) do
    sacks
    |> Enum.map(fn {left, right} -> MapSet.intersection(left, right) end)
    |> Enum.reduce([], fn elem, acc -> acc ++ MapSet.to_list(elem) end)
  end

  defp detect_badge(sacks) do
    sacks
    |> Enum.map(fn {left, right} -> MapSet.union(left, right) end)
    |> Enum.reduce(fn sack, accum -> MapSet.intersection(sack, accum) end)
    |> MapSet.to_list
    |> List.first
  end

  defp parse_line(line) do
    {left, right} = String.split_at(line, div(String.length(line), 2))
    { to_mset(left), to_mset(right) }
  end

  def priority(s) do
    [c | _ ] = String.to_charlist(s)
    if c in ?a..?z do
      c - ?a + 1
    else
      c - ?A + 27
    end
  end

  defp to_mset(item), do: MapSet.new(String.codepoints(item))
end
