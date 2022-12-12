defmodule Day11Test do
  use ExUnit.Case
  import TestHelper

  test "part 1 sample" do
    monkeys = %{
      0 => %Day11.Monkey {
        items: [79, 98],
        operation: fn old -> old * 19 end,
        test: fn value -> rem(value, 23) == 0 end,
        t: 2,
        f: 3
      },
      1 => %Day11.Monkey {
        items: [54, 65, 75, 74],
        operation: fn old -> old + 6 end,
        test: fn value -> rem(value, 19) == 0 end,
        t: 2,
        f: 0,
      },
      2 => %Day11.Monkey {
        items: [79, 60, 97],
        operation: fn old -> old * old end,
        test: fn value -> rem(value, 13) == 0 end,
        t: 1,
        f: 3,
      },
      3 => %Day11.Monkey {
        items: [74],
        operation: fn old -> old + 3 end,
        test: fn value -> rem(value, 17) == 0 end,
        t: 0,
        f: 1,
      }
    }
    r = Range.new(0, 3)
    rounds = Range.new(0, 19)

    {_, counts} = Enum.reduce(rounds, { monkeys, %{} }, fn _, {monkeys, count} ->
      Enum.reduce(r, { monkeys, count }, fn index, {monkeys, count} ->
        monkey = Map.get(monkeys, index)
        monkeys = monkey.items
        |> Enum.map(&Day11.Monkey.inspect_item(monkey, &1))
        |> Enum.reduce(monkeys, fn {to_id, worry}, monkeys ->
          Map.put(monkeys, to_id, Day11.Monkey.take_item(monkeys[to_id], worry))
        end)

        count = Map.merge(count, %{ index => length(monkey.items) }, fn _, v1, v2 -> v1 + v2 end)
        { Map.put(monkeys, index, Day11.Monkey.empty(monkey)), count }
      end)
    end)

    ans = counts
    |> Map.values
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.reduce(&(&1 * &2))
    assert ans == 10605

  end

  test "part 1 solution" do
    monkeys = %{
      0 => %Day11.Monkey {
        items: [92, 73, 86, 83, 65, 51, 55, 93],
        operation: fn old -> old * 5 end,
        test: fn v -> rem(v, 11) == 0 end,
        t: 3,
        f: 4,
      },

      1 => %Day11.Monkey {
        items: [99, 67, 62, 61, 59, 98],
        operation: fn old -> old * old end,
        test: fn v -> rem(v, 2) == 0 end,
        t: 6,
        f: 7,
      },

      2 => %Day11.Monkey {
        items: [81, 89, 56, 61, 99],
        operation: fn old -> old * 7 end,
        test: fn v -> rem(v, 5) == 0 end,
        t: 1,
        f: 5,
      },

      3 => %Day11.Monkey {
        items: [97, 74, 68],
        operation: fn old -> old + 1 end,
        test: fn v -> rem(v, 17) == 0 end,
        t: 2,
        f: 5,
      },

      4 => %Day11.Monkey {
        items: [78, 73],
        operation: fn old -> old + 3 end,
        test: fn v -> rem(v, 19) == 0 end,
        t: 2,
        f: 3,
      },

      5 => %Day11.Monkey {
        items: [50],
        operation: fn old -> old + 5 end,
        test: fn v -> rem(v, 7) == 0 end,
        t: 1,
        f: 6,
      },

      6 => %Day11.Monkey {
        items: [95, 88, 53, 75],
        operation: fn old -> old + 8 end,
        test: fn v -> rem(v, 3) == 0 end,
        t: 0,
        f: 7,
      },

      7 => %Day11.Monkey {
        items: [50, 77, 98, 85, 94, 56, 89],
        operation: fn old -> old + 2 end,
        test: fn v -> rem(v, 13) == 0 end,
        t: 4,
        f: 0,
      },

    }
    r = Range.new(0, 7)
    rounds = Range.new(0, 19)

    {_, counts} = Enum.reduce(rounds, { monkeys, %{} }, fn _, {monkeys, count} ->
      Enum.reduce(r, { monkeys, count }, fn index, {monkeys, count} ->
        monkey = Map.get(monkeys, index)
        monkeys = monkey.items
        |> Enum.map(&Day11.Monkey.inspect_item(monkey, &1))
        |> Enum.reduce(monkeys, fn {to_id, worry}, monkeys ->
          Map.put(monkeys, to_id, Day11.Monkey.take_item(monkeys[to_id], worry))
        end)

        count = Map.merge(count, %{ index => length(monkey.items) }, fn _, v1, v2 -> v1 + v2 end)
        { Map.put(monkeys, index, Day11.Monkey.empty(monkey)), count }
      end)
    end)

    ans = counts
    |> Map.values
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.reduce(&(&1 * &2))

    assert ans == 120756
  end

  test "part 2 solution" do
    monkeys = %{
      0 => %Day11.Monkey {
        items: [92, 73, 86, 83, 65, 51, 55, 93],
        operation: fn old -> old * 5 end,
        test: fn v -> rem(v, 11) == 0 end,
        t: 3,
        f: 4,
      },

      1 => %Day11.Monkey {
        items: [99, 67, 62, 61, 59, 98],
        operation: fn old -> old * old end,
        test: fn v -> rem(v, 2) == 0 end,
        t: 6,
        f: 7,
      },

      2 => %Day11.Monkey {
        items: [81, 89, 56, 61, 99],
        operation: fn old -> old * 7 end,
        test: fn v -> rem(v, 5) == 0 end,
        t: 1,
        f: 5,
      },

      3 => %Day11.Monkey {
        items: [97, 74, 68],
        operation: fn old -> old + 1 end,
        test: fn v -> rem(v, 17) == 0 end,
        t: 2,
        f: 5,
      },

      4 => %Day11.Monkey {
        items: [78, 73],
        operation: fn old -> old + 3 end,
        test: fn v -> rem(v, 19) == 0 end,
        t: 2,
        f: 3,
      },

      5 => %Day11.Monkey {
        items: [50],
        operation: fn old -> old + 5 end,
        test: fn v -> rem(v, 7) == 0 end,
        t: 1,
        f: 6,
      },

      6 => %Day11.Monkey {
        items: [95, 88, 53, 75],
        operation: fn old -> old + 8 end,
        test: fn v -> rem(v, 3) == 0 end,
        t: 0,
        f: 7,
      },

      7 => %Day11.Monkey {
        items: [50, 77, 98, 85, 94, 56, 89],
        operation: fn old -> old + 2 end,
        test: fn v -> rem(v, 13) == 0 end,
        t: 4,
        f: 0,
      },

    }
    r = Range.new(0, 7)
    rounds = Range.new(0, 9999)

    {_, counts} = Enum.reduce(rounds, { monkeys, %{} }, fn _, {monkeys, count} ->
      Enum.reduce(r, { monkeys, count }, fn index, {monkeys, count} ->
        monkey = Map.get(monkeys, index)
        monkeys = monkey.items
        |> Enum.map(&Day11.Monkey.inspect_item(monkey, &1, p2: true))
        |> Enum.reduce(monkeys, fn {to_id, worry}, monkeys ->
          Map.put(monkeys, to_id, Day11.Monkey.take_item(monkeys[to_id], worry))
        end)

        count = Map.merge(count, %{ index => length(monkey.items) }, fn _, v1, v2 -> v1 + v2 end)
        { Map.put(monkeys, index, Day11.Monkey.empty(monkey)), count }
      end)
    end)

    ans = counts
    |> Map.values
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.reduce(&(&1 * &2))

    assert ans == 120756
  end
end
