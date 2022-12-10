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

  defmodule Screen do
    @type t :: %Screen { pixels: map, position: { integer, integer }, width: 40, height: 6 }
    defstruct [:pixels, :position, width: 40, height: 6]

    @spec new :: t
    def new do
      %Screen { pixels: Map.new, position: {0, 0} }
    end

    @spec put_pixel(t, integer) :: t
    def put_pixel(s = %Screen { pixels: pixels, position: { x, y } }, center) do
      lit = x >= center - 1 && x <= center + 1
      pixels = Map.put(pixels, {x, y}, if lit do "#" else "." end)
      position = if x == s.width - 1 do { 0, y + 1 } else { x + 1, y } end

      %Screen{ pixels: pixels, position: position, width: s.width, height: s.height }
    end
  end

  defimpl String.Chars, for: Screen do
    def to_string(s) do
      Range.new(0, s.height - 1)
      |> Enum.map(fn y ->
        Range.new(0, s.width - 1)
        |> Enum.map(fn x -> Map.get(s.pixels, {x, y}) end)
        |> Enum.join("")
      end)
      |> Enum.join("\n")
    end
  end

  defmodule CPU do
    @type t :: %CPU { registers: map, elapsed: non_neg_integer, screen: Screen.t }

    defstruct [:registers, :screen, elapsed: 0]

    @spec new :: t
    def new do
      %CPU { registers: %{ "X" => 1 }, elapsed: 0, screen: Screen.new }
    end

    @spec evaluate_instruction(t, Instruction.t) :: t
    def evaluate_instruction(cpu, instruction = %Instruction { opcode: opcode, operands: operands }) do
      timing = Instruction.cycles(instruction)
      x = Map.get(cpu.registers, "X")
      screen = Range.new(cpu.elapsed + 1, cpu.elapsed + timing)
      |> Enum.reduce(cpu.screen, fn _, screen -> Screen.put_pixel(screen, x) end)

      {_, r} = case opcode do
            :addx -> Map.get_and_update!(cpu.registers, "X", fn v -> {v, v + elem(operands, 0)} end)
            :noop -> {0, Map.new}
            _ -> raise "Unexpected opcode: #{opcode}"
          end

      %CPU {
        screen: screen,
        registers: Map.merge(cpu.registers, r),
        elapsed: cpu.elapsed + timing
      }
    end

    @spec evaluate_program(t, list(Instruction.t)) :: t
    def evaluate_program(cpu, instructions) do
      instructions
      |> Enum.reduce(cpu, &evaluate_instruction(&2, &1))
    end
  end
end
