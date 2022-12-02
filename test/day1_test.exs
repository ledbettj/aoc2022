defmodule Day1Test do
  import TestHelper
  use ExUnit.Case

  test "part 1 solution" do
    ans = input_lines(1)
    |> Day1.parse
    |> Day1.most_calories_per_elf

    assert ans == 68_467
  end

  test "part 2 solution" do
    ans = input_lines(1)
    |> Day1.parse
    |> Day1.most_calories_per_elf(3)

    assert ans == 203_420
  end
end
