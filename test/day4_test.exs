defmodule Day4Test do
  use ExUnit.Case
  import TestHelper

  @sample """
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"""
  test "part 1 example" do
    ans = @sample
    |> String.trim
    |> String.split("\n")
    |> Day4.parse
    |> Enum.filter(&Day4.one_fully_contains_other?/1)

    assert length(ans) == 2
  end

  test "part 1 answer" do
    ans = input_lines(4)
    |> Day4.parse
    |> Enum.filter(&Day4.one_fully_contains_other?/1)

    assert length(ans) == 540
  end

  test "part 2 answer" do
    ans = input_lines(4)
    |> Day4.parse
    |> Enum.filter(&Day4.overlaps?/1)

    assert length(ans) == 872
  end

end
