defmodule TestHelper do
  @spec input_lines(integer) :: list(String.t())
  def input_lines(day) do
    input(day)
    |> String.trim
    |> String.split("\n")
  end

  def input(day) do
    Path.join(["test", "inputs", "day#{day}.txt"])
    |> File.read!
  end
end

ExUnit.start()
