#!/usr/bin/env ruby
require 'set'

sample = <<EOF
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
EOF

module Welp
  refine Integer do
    def sign
      self > 0 ? 1 : self < 0 ? -1 : 0
    end
  end
end

using Welp

class Cave
  attr_reader :grid, :spawn

  def initialize(blob)
    @grid = blob.strip.lines.reduce({}) do |grid, line|
      line.strip.split(' -> ').each_cons(2).reduce(grid) do |grid, (a, b)|
        x1, y1 = a.split(',').map(&:to_i)
        x2, y2 = b.split(',').map(&:to_i)

        run = (x2 - x1).sign
        rise = (y2 - y1).sign

        px, py = x1, y1
        while px != x2 || py != y2
          grid[[px, py]] = '#'
          px += run
          py += rise
        end
        grid[[px, py]] = '#'

        grid
      end
    end

    @not_escapes = Set.new
    @spawn = [500,0]
  end

  def step
    moved = nil
    bottom.downto(top).each do |y|
      (left..right).each do |x|
        case grid.fetch([x,y], ' ')
        when ' '
          next
        when '.'
          opts = [[x, y + 1],
                 [x - 1, y + 1],
                 [x + 1, y + 1]]
          dest = opts.find{|p| grid.fetch(p, ' ') == ' ' }
          if dest
            grid[[x,y]] = ' '
            grid[dest] = '.'
            moved = dest
          end
        end
      end
    end

    # check for escape.
    if moved
      mx, my = moved
      return :moved if @not_escapes.include?(moved)
      escape = ((my + 1)..bottom).all? {|y| grid.fetch([mx, y], ' ') == ' '}
      @not_escapes.add([mx,my]) unless escape
      escape ? :escape : :moved
    else
    :still
    end
  end

  def spawn!
    grid[spawn] = '.'
  end

  def sand_count
    grid.values.count{ |v| v == '.' }
  end

  def to_s
    (top..bottom).map do |y|
      (left..right).map do |x|
        grid.fetch([x,y], ' ')
      end.join("")
    end.join("\n")
  end

  def left
    grid.keys.map(&:first).min
  end

  def top
    grid.keys.map(&:last).min
  end

  def right
    grid.keys.map(&:first).max
  end

  def bottom
    grid.keys.map(&:last).max
  end
end

# c = Cave.new(sample)
# c.sand!
# loop do
#   case c.step
#   when :still then c.sand!
#   when :moved then next
#   when :escape then break
#   end
# end
# puts "sand count is #{c.sand_count - 1}"


# c = Cave.new(File.read('../test/inputs/day14.txt'))
# c.sand!
# puts c.to_s

# loop do
#   case c.step
#   when :still then c.sand!
#   when :moved then next
#   when :escape then break
#   end
#   puts c.to_s
# end
# puts "sand count is #{c.sand_count - 1}"

class Cave2
  attr_reader :grid, :spawn, :floor_y

  def sand?(p)
    grid.fetch(p, ' ') == '.'
  end

  def empty?(p)
    _, y = p
    grid.fetch(p, ' ') == ' ' && y < floor_y
  end

  def put(p)
    grid[p] = '.'
  end

  def initialize(blob)
    @grid = blob.strip.lines.reduce({}) do |grid, line|
      line.strip.split(' -> ').each_cons(2).reduce(grid) do |grid, (a, b)|
        x1, y1 = a.split(',').map(&:to_i)
        x2, y2 = b.split(',').map(&:to_i)

        run = (x2 - x1).sign
        rise = (y2 - y1).sign

        px, py = x1, y1
        while px != x2 || py != y2
          grid[[px, py]] = '#'
          px += run
          py += rise
        end
        grid[[px, py]] = '#'

        grid
      end
    end

    @floor_y = bottom + 2
    @spawn = [500,0]
  end

  def step
    bottom.downto(top).each do |y|
      (left..right).each do |x|
        case grid.fetch([x,y], ' ')
        when ' '
          next
        when '.'
          opts = [[x, y + 1],
                 [x - 1, y + 1],
                 [x + 1, y + 1]]
          dest = opts.find{|p| grid.fetch(p, ' ') == ' ' }
          if dest && dest.last < floor_y
            grid.delete([x,y])
            grid[dest] = '.'
            moved = dest
          end
        end
      end
    end
  end

  def spawn!
    grid[spawn] = '.'
  end

  def sand_count
    grid.values.count{ |v| v == '.' }
  end

  def to_s
    (top..bottom).map do |y|
      (left..right).map do |x|
        grid.fetch([x,y], ' ')
      end.join("")
    end.join("\n")
  end

  def left
    grid.keys.map(&:first).min
  end

  def top
    grid.keys.map(&:last).min
  end

  def right
    grid.keys.map(&:first).max
  end

  def bottom
    grid.keys.map(&:last).max
  end
end

c = Cave2.new(sample)
while !c.sand?(c.spawn) do
  c.spawn!
  c.step
  puts c
end
puts "sand count is #{c.sand_count}"


c = Cave2.new(File.read("../test/inputs/day14.txt"))

to_put = [c.spawn]
seen = Set.new

while !to_put.empty?
  p = to_put.shift
  x, y = p
  c.put(p)
  supports = [[x - 1, y + 1],
              [x,     y + 1],
              [x + 1, y + 1],
             ]
  supports
    .select{ |s| c.empty?(s) }
    .select{ |s| !seen.include?(s) }
    .each{ |s| to_put.push(s); seen.add(s) }
end

puts c.sand_count

