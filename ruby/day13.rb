#!/usr/bin/env ruby

sample = <<EOF
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
EOF

class Wrapper
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def <=>(other)
    compare(item, other.item)
  end

  def ==(other)
    item == other.item
  end

  private

  def compare(left, right)
    if left.is_a?(Integer) && right.is_a?(Integer)
      return -1 if left < right
      return 1 if left > right
      0
    elsif left.is_a?(Array) && right.is_a?(Array)
      left.each_with_index do |l, i|
        r = right[i]
        return 1 if r.nil?

        if (n = compare(l, r)) != 0
          return n
        end
      end

      return -1 if left.length < right.length

      0
    else
      compare(Array(left), Array(right))
    end
  end
end

class Day13
  attr_reader :items

  def initialize(blob)
    @items = blob
      .strip
      .split("\n\n")
      .map { |pair| pair.split("\n").map { |entry| eval(entry) } }
  end

  def ordered_indexes
    items
      .each_with_index
      .select { |(left, right), _| ordered?(left, right)  }
      .map { |_, index| index + 1 }
  end

  def part2
    @items = items.flatten(1)
    @items.push([[2]])
    @items.push([[6]])

    @items = items.map{|item| Wrapper.new(item)}

    @items.sort!

    (items.index(Wrapper.new([[2]])) + 1) * (items.index(Wrapper.new([[6]])) + 1)
  end

  def ordered?(left, right)
    if left.is_a?(Integer) && right.is_a?(Integer)
      return true if left < right
      return false if left > right
      nil
    elsif left.is_a?(Array) && right.is_a?(Array)
      left.each_with_index do |l, i|
        r = right[i]
        return false if r.nil?

        if (n = ordered?(l, r)) != nil
          return n
        end
      end

      return true if left.length < right.length

      nil
    else
      ordered?(Array(left), Array(right))
    end
  end
end

puts Day13.new(sample).ordered_indexes # == [1, 2, 4, 6]
puts Day13.new(sample).part2
puts ''
puts Day13.new(File.read("../test/inputs/day13.txt")).ordered_indexes.reduce(&:+) # == [1, 2, 4, 6]
puts Day13.new(File.read("../test/inputs/day13.txt")).part2

