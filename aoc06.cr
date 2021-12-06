DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read_lines("#{DAY}.txt").map(&.split(",").map(&.to_i)).first

def solve(days)
  fish = Hash(Int32, Int64).new { 0_i64 }
  INPUT.each { |i| fish[i] += 1_i64 }
  days.times do |_|
    newfish = Hash(Int32, Int64).new { 0_i64 }
    fish.each do |k, v|
      if k == 0
        newfish[6] += v
        newfish[8] += v
      else
        newfish[k - 1] += v
      end
    end
    fish = newfish
  end
  fish.values.sum
end

def part1
  solve 80
end

def part2
  solve 256
end

puts part1, part2
