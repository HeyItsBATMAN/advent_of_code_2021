DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read_lines("#{DAY}.txt").first.split(",").map(&.to_i)

def part1
  mid = INPUT.size // 2
  median = INPUT.sort[mid - 1..mid].sum // 2
  INPUT.map { |v| (v - median).abs }.sum
end

def part2
  sum = ->(mean : Int32) { INPUT.sum { |v|
    (v...mean).step(v > mean ? -1 : 1).to_a.map_with_index { |_, i| i + 1 }.sum
  } }
  mean = INPUT.sum / INPUT.size
  floor, ceil = mean.floor.to_i, mean.ceil.to_i
  [floor, ceil].map { |v| sum.call(v) }.min
end

puts part1, part2
