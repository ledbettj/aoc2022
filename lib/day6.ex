defmodule Day6 do
  @spec start_of_packet_position(String.t) :: non_neg_integer
  def start_of_packet_position(input), do: first_n_unique_pos(input, 4)

  @spec start_of_message_position(String.t) :: non_neg_integer
  def start_of_message_position(input), do: first_n_unique_pos(input, 14)


  @spec first_n_unique_pos(String.t, non_neg_integer) :: non_neg_integer
  defp first_n_unique_pos(input, n) do
    {_, index} = input
    |> String.graphemes
    |> Enum.chunk_every(n, 1, :discard)
    |> Enum.with_index(n)
    |> Enum.find(fn {items, _} -> MapSet.size(MapSet.new(items)) == n end)

    index
  end
end
