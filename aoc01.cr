DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read_lines("#{DAY}.txt").map(&.to_i)

def part1
  INPUT.each_cons(2).count { |pair| pair.last > pair.first }
end

def part2
  last_sum = Int32::MAX
  INPUT.each_cons(3).count { |pair|
    increase = pair.sum > last_sum
    last_sum = pair.sum
    increase
  }
end

puts part1, part2
