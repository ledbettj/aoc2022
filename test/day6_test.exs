defmodule Day6Test do
  use ExUnit.Case
  import TestHelper

  test "part1 example" do
    assert Day6.start_of_packet_position("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 7
    assert Day6.start_of_packet_position("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5
    assert Day6.start_of_packet_position("nppdvjthqldpwncqszvftbrmjlhg") == 6
    assert Day6.start_of_packet_position("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10
    assert Day6.start_of_packet_position("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11
  end

  test "part1 solution" do
    line = String.trim(input(6))
    assert Day6.start_of_packet_position(line) == 1_235
  end

  test "part2 solution" do
    line = String.trim(input(6))
    assert Day6.start_of_message_position(line) == 3_051
  end
end
