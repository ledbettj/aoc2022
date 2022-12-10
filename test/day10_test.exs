defmodule Day10Test do
  use ExUnit.Case
  import TestHelper

  @sample """
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
"""

  test "day 1 example" do
    program = @sample
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&Day10.Instruction.parse/1)

    {cpu, strength} = Enum.reduce(program, {Day10.CPU.new, 0}, fn instruction, {cpu, sum} ->
      window = Range.new(cpu.elapsed + 1, cpu.elapsed + Day10.Instruction.cycles(instruction))
      cycle = Enum.find(window, fn n -> rem(n - 20, 40) == 0 end)

      sum = if !is_nil(cycle) do
        strength = cycle * Map.get(cpu.registers, "X")
        sum + strength
      else
        sum
      end
      { Day10.CPU.evaluate_instruction(cpu, instruction), sum }
    end)

    assert strength  == 13140
  end

  test "day 2 example" do
    program = @sample
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&Day10.Instruction.parse/1)

    cpu = Enum.reduce(program, Day10.CPU.new, fn instruction, cpu ->
      Day10.CPU.evaluate_instruction(cpu, instruction)
    end)

    IO.puts(cpu.screen)
  end

  test "day 1 solution" do
    program = Enum.map(input_lines(10), &Day10.Instruction.parse/1)

    {cpu, strength} = Enum.reduce(program, {Day10.CPU.new, 0}, fn instruction, {cpu, sum} ->
      window = Range.new(cpu.elapsed + 1, cpu.elapsed + Day10.Instruction.cycles(instruction))
      cycle = Enum.find(window, fn n -> rem(n - 20, 40) == 0 end)

      sum = if !is_nil(cycle) do
        strength = cycle * Map.get(cpu.registers, "X")
        sum + strength
      else
        sum
      end
      { Day10.CPU.evaluate_instruction(cpu, instruction), sum }
    end)

    assert strength  == 11_820
  end

  test "day 2 solution" do
    program = input_lines(10)
    |> Enum.map(&Day10.Instruction.parse/1)

    cpu = Enum.reduce(program, Day10.CPU.new, fn instruction, cpu ->
      Day10.CPU.evaluate_instruction(cpu, instruction)
    end)

    IO.puts(cpu.screen)
  end
end
