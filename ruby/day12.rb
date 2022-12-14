#!/usr/bin/env ruby
require 'set'

sample = <<EOF
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
EOF


class Day12
  attr_reader :grid, :start, :finish

  def initialize(blob, start, finish)
    @start = start
    @finish = finish
    @grid = blob
      .strip
      .lines
      .each_with_index
      .flat_map do |line, y|
        line
          .chars
          .each_with_index
          .map do |char, x|
            ord = case char
                  when 'S' then puts "start is #{x},#{y}"; 'a'.ord
                  when 'E' then puts "end is #{x},#{y}"; 'z'.ord
                  else char.ord
                  end
            [[x,y], ord]
          end
      end
      .to_h
  end

  def shortest_cost
    visited = Set.new
    to_visit = []
    cost = 0
    current = start

    loop do
      visited.add(current)

      neighbors = visitable_neighbors(current, visited, cost, finish)
      neighbors.each { |entry| visited.add(entry[:point]) }

      to_visit += neighbors
      to_visit.sort_by!{ |entry| entry[:cost] + entry[:h] }
      entry = to_visit.shift
      cost = entry[:cost]
      current = entry[:point]
      return cost if current == finish
    end
  end

  private

  def visitable_neighbors(from, visited, cost, dest)
    offsets = [[0, 1],
               [1, 0],
               [0, -1],
               [-1, 0]]
    x, y = from
    dest_x, dest_y = dest

    offsets
      .map { |(dx, dy)| [x + dx, y + dy] }
      .select { |p| !visited.include?(p) }
      .select { |p| grid.key?(p) && grid[p] <= grid[from] + 1 }
      .map { |p| { cost: cost + 1, point: p, h: (dest_x - p.first).abs + (dest_y - p.last).abs  } }
  end
end

class Day12p2
  attr_reader :grid, :start, :finish

  def initialize(blob)
    @start = start
    @finish = Set.new
    @grid = blob
      .strip
      .lines
      .each_with_index
      .flat_map do |line, y|
        line
          .chars
          .each_with_index
          .map do |char, x|
            ord = case char
                  when 'S' then 'a'.ord
                  when 'E' then @start = [x,y]; 'z'.ord
                  else char.ord
                  end
            @finish.add([x,y]) if ord == 'a'.ord
            [[x,y], ord]
          end
      end
      .to_h
  end

  def shortest_cost
    visited = Set.new
    to_visit = []
    cost = 0
    current = start

    loop do
      visited.add(current)

      neighbors = visitable_neighbors(current, visited, cost)
      neighbors.each { |entry| visited.add(entry[:point]) }

      to_visit += neighbors
      to_visit.sort_by!{ |entry| entry[:cost] }
      entry = to_visit.shift
      cost = entry[:cost]
      current = entry[:point]
      return cost if finish.include?(current)
    end
  end

  private

  def visitable_neighbors(from, visited, cost)
    offsets = [[0, 1],
               [1, 0],
               [0, -1],
               [-1, 0]]
    x, y = from

    offsets
      .map { |(dx, dy)| [x + dx, y + dy] }
      .select { |p| !visited.include?(p) }
      .select { |p| grid.key?(p) && grid[p] + 1 >= grid[from] }
      .map { |p| { cost: cost + 1, point: p } }
  end
end

d = Day12.new(sample, [0, 0], [5, 2])
puts d.shortest_cost

d = Day12.new(File.read("../test/inputs/day12.txt"), [0, 20], [52, 20])
puts d.shortest_cost

d = Day12p2.new(sample)
puts d.shortest_cost

d = Day12p2.new(File.read("../test/inputs/day12.txt"))
puts d.shortest_cost
