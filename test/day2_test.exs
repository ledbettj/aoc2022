defmodule Day2Test do
  import TestHelper
  use ExUnit.Case

  test "part 1 example" do
    input = String.split("A Y\nB X\n C Z", "\n")
    score = Day2.parse(input)
    |> Enum.map(&Day2.result(elem(&1, 0), elem(&1, 1)))
    |> Enum.sum

    assert score == 15
  end

  test "part 1 solution" do
    score = Day2.parse(input_lines(2))
    |> Enum.map(&Day2.result(elem(&1, 0), elem(&1, 1)))
    |> Enum.sum

    assert score == 11_475
  end

  test "part 2 example" do
    input = String.split("A Y\nB X\n C Z", "\n")
    score = Day2.parse_p2(input)
    |> Enum.map(&Day2.result_p2(elem(&1, 0), elem(&1, 1)))
    |> Enum.sum

    assert score == 12
  end

  test "part 2 solution" do
    score = Day2.parse_p2(input_lines(2))
    |> Enum.map(&Day2.result_p2(elem(&1, 0), elem(&1, 1)))
    |> Enum.sum

    assert score == 16_862
  end
end
