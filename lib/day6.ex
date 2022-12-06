defmodule Day6 do
  def start_of_packet_position(input) do
    first_n_unique_pos(input, 4)
  end

  def start_of_message_position(input) do
    first_n_unique_pos(input, 14)
  end

  defp first_n_unique_pos(input, n) do
    {_, index} = input
    |> String.graphemes
    |> Enum.chunk_every(n, 1, :discard)
    |> Enum.with_index(n)
    |> Enum.find(fn {items, _} -> MapSet.size(MapSet.new(items)) == n end)

    index
  end
end
