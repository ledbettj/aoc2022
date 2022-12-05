defmodule Day5 do
  @type move :: %{required(:from) => integer, required(:to) => integer, required(:count) => integer }
  @type stack :: list(String.t)
  @type stacks :: %{ integer => stack }

  @spec parse([String.t, ...]) :: {stacks, list(move)}
  def parse([crates, moves]) do
    rows = crates
    |> String.split("\n")
    |> Enum.reverse
    |> Enum.drop(1)
    |> Enum.map(&parse_crate_line/1)

    len = length(List.first(rows))

    crates = Range.new(0, len - 1)
    |> Enum.map(fn col_index ->
      rows
      |> Enum.map(&Enum.at(&1, col_index))
      |> Enum.reverse
      |> Enum.join
    end)
    |> Enum.with_index(1)
    |> Enum.map(fn {value, index} -> {index, value} end)
    |> Map.new

    moves = moves
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&parse_move_line/1)

    {crates, moves}
  end

  @spec parse_move_line(String.t) :: move
  defp parse_move_line(line) do
    ~r/move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)/
    |> Regex.named_captures(line)
    |> Enum.map(fn {k, v} -> {String.to_atom(k), String.to_integer(v, 10)} end)
    |> Map.new
  end

  @spec parse_crate_line(String.t) :: stack
  defp parse_crate_line(line) do
    ~r/(\s{3}|\[.\])\s?/
    |> Regex.scan(line, capture: :all_but_first)
    |> Enum.map(fn
      ["   "] -> nil
      [s] -> String.at(s, 1)
    end)
  end

  @spec evaluate_all(stacks, list(move)) :: stacks
  def evaluate_all(crates, moves, opts \\ []) do
    Enum.reduce(moves, crates, &Day5.evaluate(&2, &1, opts))
  end

  @spec top(stacks) :: String.t
  def top(crates) do
    crates
    |> Enum.map(fn {_, v} -> String.at(v, 0) end)
    |> Enum.join
  end

  @spec evaluate_all(stacks, move) :: stacks
  def evaluate(crates, move, opts \\ []) do
    from   = move[:from]
    to     = move[:to]
    count  = move[:count]
    {take, remain} = String.split_at(crates[from], count)

    dest = if Keyword.get(opts, :part2, false) do
      take
    else
      String.reverse(take)
    end <> crates[to]

    Map.merge(crates, %{ from => remain, to => dest })
  end
end
