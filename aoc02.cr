DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read_lines("#{DAY}.txt").map(&.split(" "))

def part1
  depth, hoz = 0, 0
  INPUT.each do |line|
    cmd, amnt = line.first, line.last.to_i
    case cmd
    when "forward" then hoz += amnt
    when "down"    then depth += amnt
    when "up"      then depth -= amnt
    end
  end
  return depth * hoz
end

def part2
  depth, hoz, aim = 0, 0, 0
  INPUT.each do |line|
    cmd, amnt = line.first, line.last.to_i
    case cmd
    when "forward"
      hoz += amnt
      depth += aim * amnt
    when "down" then aim += amnt
    when "up"   then aim -= amnt
    end
  end
  return depth * hoz
end

puts part1, part2
