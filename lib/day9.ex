defmodule Day9 do
  def parse(lines) do
    Enum.map(lines, &parse_line/1)
  end

  def evaluate(commands) do
    state = %{ head: { 0, 0 }, tail: { 0, 0 }, visited: MapSet.new([{0, 0}]) }
    Enum.reduce(commands, state, &evaluate_command/2)
  end

  defp evaluate_command({dx, dy, count}, state) do
    Range.new(1, count)
    |> Enum.reduce(state, fn _, accum -> move_head({dx, dy}, accum) end)
  end

  defp move_head({dx, dy}, %{ head: {hx, hy}, tail: {tx, ty}, visited: visited }) do
    #IO.puts("head is at #{hx},#{hy}, tail is at #{tx},#{ty}")
    {hx, hy} = {hx + dx, hy + dy}

    diff = {hx - tx, hy - ty }
    tail = move_tail({tx, ty}, diff)
    %{ head: {hx, hy}, tail: tail, visited: MapSet.put(visited, tail) }
  end

  defp move_tail(tail, {dx, dy}) when abs(dx) <= 1 and abs(dy) <= 1, do: tail
  defp move_tail({tx, ty}, {dx, dy}) do
    {tx + sign(dx), ty + sign(dy) }
  end

  defp sign(n) when n == 0, do: 0
  defp sign(n) when n > 0, do: 1
  defp sign(n) when n < 0, do: -1


  defp parse_line(line) do
    [dir, amount] = String.split(line, " ")
    amount = String.to_integer(amount, 10)

    case dir do
      "L" -> { -1, 0, amount }
      "R" -> { 1, 0, amount }
      "U" -> { 0, -1, amount}
      "D" -> { 0, 1, amount }
      other -> raise "Giving up: #{other}"
    end
  end
end
