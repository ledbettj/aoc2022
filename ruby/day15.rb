#!/usr/bin/env ruby
require 'set'

sample = <<EOF
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
EOF

class Scanner
  REGEX = /sensor at x=(?<sx>-?\d+), y=(?<sy>-?\d+).*beacon is at x=(?<bx>-?\d+), y=(?<by>-?\d+)/i

  attr_reader :sensors
  attr_reader :beacons

  def initialize(blob)
    @sensors = []
    @beacons = Set.new

    blob
      .strip
      .lines
      .each do |line|
        sx, sy, bx, by = REGEX
          .match(line)
          .captures
          .map(&:to_i)

        sp = { x: sx, y: sy }
        bp = { x: bx, y: by }
        range = distance(sp, bp)
        sensors.push(sp.merge(r: range))
        beacons.add(bp)
      end
  end

  def row_coverage(row_y)
    covered = Set.new
    sensors.each do |s|
      s => { x: x, y: y, r: r }
      y_dist = (row_y - y).abs

      # can't reach that row at all
      next if y_dist > r

      # amount covered to the left and right of [x, row_y]
      x_range = r - y_dist

      ((x - x_range)..(x + x_range)).each do |rx|
        covered.add(x: rx, y: row_y)
      end
    end

    covered - beacons
  end

  def covered?(p)
    beacons.include?(p) || sensors.any? { |s| distance(s, p) <= s[:r] }
  end

  def distance(p1, p2)
    (p2[:x]- p1[:x]).abs + (p2[:y] - p1[:y]).abs
  end

  def uncovered_border_point(s, bl, bh)

    if s[:x] + s[:r] < bl || s[:x] - s[:r] > bh || s[:y] + s[:r] < bl || s[:y] - s[:r] > bh
      return Set.new
    end

    # one unit outside of the border of this rect
    r = s[:r] + 1
    points = (0..r)
    .flat_map { |dist| [dist, -dist] }
    .flat_map { |x| [{x: s[:x] + x, y: s[:y] + (r - x.abs)}, {x: s[:x] + x, y: s[:y] - (r - x.abs)}] }
    .filter { |p| p[:x] >= bl && p[:x] <= bh && p[:y] >= bl && p[:y] <= bh }
    .find { |p| !covered?(p) }
  end

  def find_beacon(bl, bh)
    sensors.find { |s| print '.'; uncovered_border_point(s, bl, bh) }
  end
end

s = Scanner.new(sample)
puts s.row_coverage(10).length

#s = Scanner.new(File.read('../test/inputs/day15.txt'))
#puts s.row_coverage(2000000).length

s = Scanner.new(sample)
p = s.find_beacon(0, 20)
puts p[:x] * 4_000_000 + p[:y]


s = Scanner.new(File.read('../test/inputs/day15.txt'))
p = s.find_beacon(0, 4000000)
puts p[:x] * 4_000_000 + p[:y]
