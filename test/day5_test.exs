defmodule Day5Test do
  use ExUnit.Case
  import TestHelper

  @sample """
    [D]    
[N] [C]    
[Z] [M] [P]
1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"""

  test "parses the input correctly" do
    ans = @sample
    |> String.split("\n\n")
    |> Day5.parse

    assert ans == {
      %{
        1 => "NZ",
        2 => "DCM",
        3 => "P"
      },
      [
        %{ count: 1, from: 2, to: 1 },
        %{ count: 3, from: 1, to: 3 },
        %{ count: 2, from: 2, to: 1 },
        %{ count: 1, from: 1, to: 2 },
      ]
    }
  end

  test "part one sample" do
    { crates, moves } = @sample
    |> String.split("\n\n")
    |> Day5.parse

    c = Day5.evaluate_all(crates, moves)
    assert Day5.top(c) == "CMZ"
  end

  test "part one" do
    { crates, moves } = input(5)
    |> String.split("\n\n")
    |> Day5.parse

    c = Day5.evaluate_all(crates, moves)
    assert Day5.top(c) == "BWNCQRMDB"
  end

  test "part two" do
    { crates, moves } = input(5)
    |> String.split("\n\n")
    |> Day5.parse

    c = Day5.evaluate_all(crates, moves, part2: true)
    assert Day5.top(c) == "NHWZCBNBF"
  end
end
