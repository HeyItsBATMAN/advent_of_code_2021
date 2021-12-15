DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read_lines("#{DAY}.txt")

MAP = INPUT.map_with_index { |line, y| line.chars.map_with_index { |char, x|
  { {x, y}, char.to_i }
} }.flatten.to_h
SIZE = INPUT.first.size

def get_adjacent(a)
  [{0, 1}, {0, -1}, {1, 0}, {-1, 0}].map { |b| {a[0] + b[0], a[1] + b[1]} }
    .select { |pos| MAP[pos]? }.to_h { |pos| {pos, MAP[pos]} }
end

def solve
  seen = Set(Tuple(Int32, Int32)).new
  queue = [{ {0, 0}, 0 }]
  maxx, maxy = MAP.max_of(&.first.first), MAP.max_of(&.first.last)
  final = {maxx, maxy}
  until queue.empty?
    coord, total_risk = queue.delete(queue.min_by(&.last)).not_nil!
    next if !seen.add?(coord)
    return total_risk if coord == final
    get_adjacent(coord).each { |n, r| queue << {n, total_risk + r} }
  end
end

def part1
  solve
end

def part2
  (0...(SIZE * 5)).each { |y| (0...(SIZE * 5)).each { |x|
    new_risk = MAP[{x % SIZE, y % SIZE}] + (x // SIZE) + (y // SIZE)
    new_risk = (new_risk - 9) if new_risk > 9
    MAP[{x, y}] = new_risk
  } }

  solve
end

puts part1, part2
