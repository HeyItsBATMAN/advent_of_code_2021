DAY    = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT  = File.read_lines("#{DAY}.txt").first.split(": ").last.split(", ").map(&.split("=").last.split("..").map(&.to_i))
XRANGE = (INPUT[0][0]..INPUT[0][1])
YRANGE = (INPUT[1][0]..INPUT[1][1])

def simulate(xv, yv)
  x, y, maxy = 0, 0, Int32::MIN
  loop do
    x += xv
    y += yv
    maxy = y if y > maxy
    xv = xv > 0 ? xv - 1 : xv < 0 ? xv + 1 : xv
    yv -= 1
    return maxy if XRANGE.covers?(x) && YRANGE.covers?(y)
    break if x > XRANGE.end || y < YRANGE.begin
  end
  Int32::MIN
end

def part1
  (0..100).to_a.max_of { |xv| (0..100).to_a.max_of { |yv| simulate(xv, yv) } }
end

def part2
  (-500..500).to_a.sum { |xv| (-500..500).to_a.count { |yv| simulate(xv, yv) != Int32::MIN } }
end

puts part1, part2
