defmodule Day9Test do
  use ExUnit.Case
  import TestHelper

  @sample """
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
"""
  test "part 1 example" do
    cmds = @sample
    |> String.trim
    |> String.split("\n")
    |> Day9.parse

    rc = Day9.evaluate(cmds)
    assert MapSet.size(rc.visited) == 13
  end

  test "part 1 solution" do
    cmds = input_lines(9)
    |> Day9.parse

    rc = Day9.evaluate(cmds)
    assert MapSet.size(rc.visited) == 5_779
  end
end
