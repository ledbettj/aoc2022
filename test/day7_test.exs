defmodule Day7Test do
  use ExUnit.Case
  import TestHelper

  @sample """
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
"""

  test "part 1 example" do
    items = @sample
    |> String.trim
    |> String.split("\n")
    |> Day7.parse

    {items, _} = Day7.populate_sizes(items, "")
    ans = items
    |> Enum.filter(fn {_, v} -> v.dir && v.size <= 100000 end)
    |> Enum.map(fn {_ ,v} -> v.size end)
    |> Enum.sum

    assert ans == 95437
  end

  test "part 2 example" do
    items = @sample
    |> String.trim
    |> String.split("\n")
    |> Day7.parse

    {items, _} = Day7.populate_sizes(items, "")
    unused = 70000000 - items[""].size
    needed = 30000000
    to_delete = needed - unused
    IO.puts "need to delete #{to_delete}"

    {path, node} = items
    |> Enum.filter(fn {_, v} -> v.dir && v.size >= to_delete end)
    |> Enum.min_by(fn {_, v} -> v.size - to_delete end)

    assert path == "/d"
    assert node.size == 24933642
  end

  test "part 1 solution" do
    items = input_lines(7)
    |> Day7.parse

    {items, _} = Day7.populate_sizes(items, "")
    ans = items
    |> Enum.filter(fn {k, v} -> v.dir && v.size <= 100000 end)
    |> Enum.map(fn {k,v} -> v.size end)
    |> Enum.sum

    assert ans == 1_350_966
  end

  test "part 2 solution" do
    items = input_lines(7)
    |> Day7.parse

    {items, _} = Day7.populate_sizes(items, "")
    unused = 70000000 - items[""].size
    needed = 30000000
    to_delete = needed - unused
    IO.puts "need to delete #{to_delete}"

    {path, node} = items
    |> Enum.filter(fn {_, v} -> v.dir && v.size >= to_delete end)
    |> Enum.min_by(fn {_, v} -> v.size - to_delete end)

    assert node.size == 6296435
  end
end
