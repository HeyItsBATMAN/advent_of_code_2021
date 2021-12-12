DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read_lines("#{DAY}.txt").map(&.split("->").join(",").split(",").map(&.to_i))

def solve(consider_diagonal)
  map = Hash(Tuple(Int32, Int32), Int32).new { 0 }
  INPUT.each do |line|
    x1, y1, x2, y2 = line
    next if x1 != x2 && y1 != y2 && !consider_diagonal
    until x1 == x2 && y1 == y2
      map[{x1, y1}] += 1
      x1 += x1 > x2 ? -1 : 1 if x1 != x2
      y1 += y1 > y2 ? -1 : 1 if y1 != y2
    end
    map[{x2, y2}] += 1 # add final position
  end
  map.count { |_, v| v > 1 }
end

def part1
  solve false
end

def part2
  solve true
end

puts part1
puts part2
