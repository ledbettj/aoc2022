defmodule Day3Test do
  use ExUnit.Case
  import TestHelper

  test "part 1 example" do
    input = """
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMwD
    """

    lines = String.split(String.trim(input), "\n")
    ans = lines
    |> Day3.parse
    |> Day3.common_items
    |> Enum.map(&Day3.priority/1)
    |> Enum.sum

    assert ans == 157
  end

  test "part 2 example" do
    input = """
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMwD
    """

    lines = String.split(String.trim(input), "\n")
    ans = lines
    |> Day3.parse
    |> Day3.find_badges
    |> Enum.map(&Day3.priority/1)
    |> Enum.sum

    assert ans == 70
  end

  test "part 1 solution" do
    ans = input_lines(3)
    |> Day3.parse
    |> Day3.common_items
    |> Enum.map(&Day3.priority/1)
    |> Enum.sum
    assert ans == 8_349
  end

  test "part 2 solution" do
    ans = input_lines(3)
    |> Day3.parse
    |> Day3.find_badges
    |> Enum.map(&Day3.priority/1)
    |> Enum.sum
    assert ans == 2_681
  end
end
