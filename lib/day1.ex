defmodule Day1 do
  @type elf :: list(integer)

  @spec parse(list(String.t)) :: list(elf)
  def parse(input) do
    chunk_fn = fn
      "", accum   -> { :cont, accum, [] }
      elem, accum -> { :cont, [String.to_integer(elem, 10) | accum] }
    end

    after_fn = fn
      []    -> { :cont, [] }
      accum -> { :cont, accum, [] }
    end

    Enum.chunk_while(input, [], chunk_fn, after_fn)
  end

  @spec most_calories_per_elf(list(elf)) :: integer
  def most_calories_per_elf(elves) do
    elves
    |> Enum.map(&Enum.sum/1)
    |> Enum.max
  end

  @spec most_calories_per_elf(list(elf), integer) :: integer
  def most_calories_per_elf(elves, count) do
    elves
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(:desc)
    |> Enum.take(count)
    |> Enum.sum
  end
end
