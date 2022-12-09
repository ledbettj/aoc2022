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


  @sample_p2 """
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
"""

  test "part 2 example" do
    cmds = @sample_p2
    |> String.trim
    |> String.split("\n")
    |> Day9.parse

    rc = Day9.evaluate_p2(cmds)
    assert MapSet.size(rc.visited) == 36
  end

  test "part 1 solution" do
    cmds = input_lines(9)
    |> Day9.parse

    rc = Day9.evaluate(cmds)
    assert MapSet.size(rc.visited) == 5_779
  end

  test "part 2 solution" do
    cmds = input_lines(9)
    |> Day9.parse

    rc = Day9.evaluate_p2(cmds)
    assert MapSet.size(rc.visited) == 2_331
  end
end
