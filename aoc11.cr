DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read_lines("#{DAY}.txt")
MAP   = INPUT.map_with_index { |line, y| line.chars.map_with_index { |char, x|
  { {x, y}, char.to_i }
} }.flatten.to_h
SIZE = INPUT.first.size - 1

def get_adjacent(a)
  [{0, 1}, {0, -1}, {1, 0}, {-1, 0}, {-1, -1}, {1, 1}, {-1, 1}, {1, -1}]
    .map { |b| {a[0] + b[0], a[1] + b[1]} }
end

def step(map, flashed)
  (0..SIZE).each { |y| (0..SIZE).each { |x| map[{x, y}] += 1 } }
  while map.count { |p, v| v > 9 && !flashed[p] } > 0
    map.select { |p, v| v > 9 && !flashed[p] }.each do |c, _|
      flashed[c] = true
      get_adjacent(c).reject { |n| flashed[n]? || !map[n]? }.each do |n|
        map[n] += 1
      end
    end
  end
  map
end

def part1
  map, flashed = MAP.clone, MAP.to_h { |k, _| {k, false} }
  Array.new(100, 0).sum { |_|
    map = step(map, flashed)
    total = flashed.values.count(true)
    flashed.select { |_, v| v }.each { |c, _| map[c] = 0; flashed[c] = false }
    total
  }
end

def part2
  map, flashed = MAP.clone, MAP.to_h { |k, _| {k, false} }
  step = 0
  loop do
    map = step(map, flashed)
    step += 1
    break if flashed.all? { |_, v| v }
    flashed.select { |_, v| v }.each { |c, _| map[c] = 0; flashed[c] = false }
  end
  step
end

puts part1, part2
