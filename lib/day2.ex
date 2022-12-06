defmodule Day2 do
  @type play :: :rock | :paper | :scissors
  @type outcome :: :win | :loss | :draw

  @values %{
    rock: 1,
    paper: 2,
    scissors: 3
  }

  @spec value(play) :: 1 | 2 | 3
  defp value(play), do: @values[play]

  @spec parse(list(String.t)) :: list({ play, play })
  def parse(lines) do
    Enum.map(lines, fn line ->
        parts = String.split(line)
      { parse_opponent(List.first(parts)), parse_self(List.last(parts)) }
      end
    )
  end

  @spec parse_p2(list(String.t)) :: list({ play, outcome })
  def parse_p2(lines) do
    Enum.map(lines, fn line ->
        parts = String.split(line)
      { parse_opponent(List.first(parts)), parse_outcome(List.last(parts)) }
      end
    )
  end

  @spec result_p2(play, outcome) :: integer
  def result_p2(opponent, outcome) do
    required_play = case { opponent, outcome } do
                      { :rock, :win } -> :paper
                      { :rock, :loss } -> :scissors
                      { :paper, :win } -> :scissors
                      { :paper, :loss } -> :rock
                      { :scissors, :win } -> :rock
                      { :scissors, :loss } -> :paper
                      { _, :draw } -> opponent
                    end
    score(outcome) + value(required_play)
  end

  @spec result(play, play) :: 1 | 2 | 3 | 4 |5 | 6 | 7 | 8 | 9
  def result(opponent, self) do
    score(opponent, self) + value(self)
  end

  @spec score(play, play) :: 0 | 3 | 6
  def score(:rock, :paper), do: 6
  def score(:paper, :scissors), do: 6
  def score(:scissors, :rock), do: 6
  def score(opponent, self) when opponent == self, do: 3
  def score(_opponent, _self), do: 0

  @spec score(outcome) :: 0 | 3 | 6
  def score(:win), do: 6
  def score(:draw), do: 3
  def score(:loss), do: 0

  @spec parse_opponent(String.t) :: play
  defp parse_opponent("A"), do: :rock
  defp parse_opponent("B"), do: :paper
  defp parse_opponent("C"), do: :scissors

  @spec parse_self(String.t) :: play
  defp parse_self("X"), do: :rock
  defp parse_self("Y"), do: :paper
  defp parse_self("Z"), do: :scissors

  @spec parse_outcome(String.t) :: outcome
  defp parse_outcome("X"), do: :loss
  defp parse_outcome("Y"), do: :draw
  defp parse_outcome("Z"), do: :win
end
