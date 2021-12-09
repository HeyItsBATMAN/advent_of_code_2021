DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read_lines("#{DAY}.txt")
MAP   = INPUT.map_with_index { |line, y| line.chars.map_with_index { |char, x|
  { {x, y}, char.to_i }
} }.flatten.to_h

def get_adjacent(a) # find valid positions in each direction from point a
  [{0, 1}, {0, -1}, {1, 0}, {-1, 0}].map { |b| {a[0] + b[0], a[1] + b[1]} }
    .to_h { |pos| {pos, MAP[pos]? || 9} } # return pair of pos and height
end

MINIMA = MAP.select { |pos, height| get_adjacent(pos).all? { |_, v| v > height } }

def get_basin_size(start)
  queue, seen = [start], Set(Tuple(Int32, Int32)).new
  while coord = queue.pop? # queue up valid adjacent if coord not seen before
    queue += get_adjacent(coord).select { |_, h| h < 9 }.keys if seen.add? coord
  end
  seen.size
end

def part1 # sum together the risk level of all minima
  MINIMA.sum { |_, height| height + 1 }
end

def part2 # get the basins for each minima and get the product of the largest 3
  MINIMA.map { |pos, _| get_basin_size(pos) }.sort.last(3).product
end

puts part1, part2
