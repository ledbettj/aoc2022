defmodule Day8Test do
  use ExUnit.Case
  import TestHelper

  @sample """
30373
25512
65332
33549
35390
"""
  
  test "part 1 examplze" do
    grid = @sample
    |> String.trim
    |> String.split("\n")
    |> Day8.parse

    assert Day8.count_visible(grid) == 21
  end

  test "part 1 solution" do
    grid = input_lines(8)
    |> Day8.parse

    assert Day8.count_visible(grid) == 1829
  end

end
