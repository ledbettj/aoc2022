defmodule TestHelper do
  @spec input_lines(integer) :: list(String.t())
  def input_lines(day) do
    Path.join(["test", "inputs", "day#{day}.txt"])
    |> File.read!
    |> String.trim
    |> String.split("\n")
  end
end

ExUnit.start()
