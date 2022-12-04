defmodule Day4 do
  @type assignments :: { Range.t, Range.t }

  @spec parse(list(String.t)) :: list(assignments)
  def parse(lines) do
    Enum.map(lines, &parse_line/1)
  end

  @spec parse_line(String.t) :: assignments
  defp parse_line(line) do
    line
    |> String.split(",")
    |> Enum.map(fn range ->
      [lo, hi] = range
      |> String.split("-")
      |> Enum.map(&String.to_integer(&1, 10))

      Range.new(lo, hi)
    end)
    |> List.to_tuple
  end

  @spec overlaps?(assignments) :: boolean
  def overlaps?({ r1, r2 }) do
    !Range.disjoint?(r1, r2)
  end

  @spec one_fully_contains_other?(assignments) :: boolean
  def one_fully_contains_other?({ r1, r2 }) do
    fully_contains?(r1, r2) || fully_contains?(r2, r1)
  end

  @spec fully_contains?(Range.t, Range.t) :: boolean
  defp fully_contains?(r1, r2) do
    r1.first <= r2.first && r1.last >= r2.last
  end
end
