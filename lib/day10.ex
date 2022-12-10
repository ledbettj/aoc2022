defmodule Day10 do
  # defmodule Register do
  #   @type t :: %Register { value: integer }
  #   defstruct [:value]

  #   @spec new(integer) :: t
  #   def new(value), do: %Register { value: value }
  # end

  defmodule Instruction do
    @type opcode :: :addx | :noop
    @type t :: %Instruction { opcode: opcode, operands: tuple }

    defstruct [:opcode, :operands]

    @spec parse(String.t) :: t
    def parse(line) do
      [opcode | rest] = String.split(line)
      %Instruction {
        opcode: String.to_atom(opcode),
        operands: List.to_tuple(Enum.map(rest, &parse_operand/1))
      }
    end

    @spec parse_operand(String.t) :: integer
    defp parse_operand(operand) do
      String.to_integer(operand, 10)
    end

    @spec cycles(t) :: 1 | 2
    def cycles(%Instruction{ opcode: :addx }), do: 2
    def cycles(%Instruction{ opcode: :noop }), do: 1
  end

  defmodule CPU do
    @type t :: %CPU { registers: map, elapsed: non_neg_integer }

    defstruct [:registers, elapsed: 0]

    @spec new :: t
    def new do
      %CPU { registers: %{ "X" => 1 }, elapsed: 0 }
    end

    @spec evaluate_instruction(t, Instruction.t) :: t
    def evaluate_instruction(cpu, instruction = %Instruction { opcode: opcode, operands: operands }) do
      {_, r} = case opcode do
            :addx -> Map.get_and_update!(cpu.registers, "X", fn v -> {v, v + elem(operands, 0)} end)
            :noop -> {0, Map.new}
            _ -> raise "Unexpected opcode: #{opcode}"
          end

      %CPU {
        registers: Map.merge(cpu.registers, r),
        elapsed: cpu.elapsed + Instruction.cycles(instruction)
      }
    end

    @spec evaluate_program(t, list(Instruction.t)) :: t
    def evaluate_program(cpu, instructions) do
      instructions
      |> Enum.reduce(cpu, &evaluate_instruction(&2, &1))
    end
  end
end
