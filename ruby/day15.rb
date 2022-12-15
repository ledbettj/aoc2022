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

        range = (sx - bx).abs + (sy - by).abs
        sensors.push(x: sx, y: sy, r: range)
        beacons.add(x: bx, y: by)
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
end

s = Scanner.new(sample)
puts s.row_coverage(10).length

s = Scanner.new(File.read('../test/inputs/day15.txt'))
puts s.row_coverage(2000000).length
