defmodule Day8 do
  @type point :: { integer, integer }
  @type forest :: %{ point => non_neg_integer }

  @spec parse(list(String.t)) :: forest
  def parse(lines) do
    lines
    |> Enum.with_index
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes
      |> Enum.map(&String.to_integer(&1, 10))
      |> Enum.with_index
      |> Enum.map(fn {height, x} -> {{x, y}, height} end)
    end)
    |> Map.new
  end

  def visibility_map(grid) do
    c = Map.keys(grid)
    width = elem(Enum.max_by(c, &elem(&1, 0)), 0)
    height = elem(Enum.max_by(c, &elem(&1, 1)), 1)

    ltr = Range.new(0, width)
    ttb = Range.new(0, height)


    Map.merge(
      count_visible_x(grid, ltr, ttb),
      count_visible_y(grid, ltr, ttb),
      fn _, v1, v2 -> v1 || v2 end
    )
  end

  def count_visible(grid) do
    grid
    |> visibility_map
    |> Map.values
    |> Enum.filter(&(&1))
    |> Enum.count
  end

  def count_visible_x(grid, inner, outer) do
    Enum.reduce(outer, %{}, fn y, visible ->
      {v1, _ } = Enum.reduce(inner, { visible, -1 }, fn x, { visible, max_seen } ->
        coords = { x, y }
        height = Map.get(grid, coords)
        visible = Map.merge(visible, %{ coords => height > max_seen })
        max_seen = Enum.max([height, max_seen])
        { visible, max_seen }
      end)
      {v2, _ } = Enum.reduce(Enum.reverse(inner), { visible, -1 }, fn x, { visible, max_seen } ->
        coords = { x, y }
        height = Map.get(grid, coords)
        visible = Map.merge(visible, %{ coords => height > max_seen })
        max_seen = Enum.max([height, max_seen])
        { visible, max_seen }
      end)

      Map.merge(v1, v2, fn _, a, b -> a || b end)
    end)
  end
 
  def count_visible_y(grid, inner, outer) do
    Enum.reduce(outer, %{}, fn x, visible ->
      {v1, _ } = Enum.reduce(inner, { visible, -1 }, fn y, { visible, max_seen } ->
        coords = { x, y }
        height = Map.get(grid, coords)
        visible = Map.merge(visible, %{ coords => height > max_seen })
        max_seen = Enum.max([height, max_seen])
        { visible, max_seen }
      end)
      {v2, _ } = Enum.reduce(Enum.reverse(inner), { visible, -1 }, fn y, { visible, max_seen } ->
        coords = { x, y }
        height = Map.get(grid, coords)
        visible = Map.merge(visible, %{ coords => height > max_seen })
        max_seen = Enum.max([height, max_seen])
        { visible, max_seen }
      end)

      Map.merge(v1, v2, fn _, a, b -> a || b end)
    end)
  end
end
