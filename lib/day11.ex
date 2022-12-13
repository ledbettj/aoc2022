defmodule Day11 do
  defmodule Monkey do
    defstruct [:operation, :test, :t, :f, items: []]

    def empty(monkey) do
      Map.merge(monkey, %{ items: [] })
    end

    def inspect_item(monkey, item, opts \\ []) do
      worry = if Keyword.get(opts, :p2, true) do
        rem(monkey.operation.(item), 9699690) # lcd of inputs
      else
        div(monkey.operation.(item), 3)
      end

      if monkey.test.(worry) do
        { monkey.t, worry }
      else
        { monkey.f, worry }
      end
    end

    def take_item(monkey, worry) do
      Map.merge(monkey, %{ items: [ worry | monkey.items ] })
    end
  end
end
