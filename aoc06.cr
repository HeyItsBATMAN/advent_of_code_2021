DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read_lines("#{DAY}.txt").map(&.split(",").map(&.to_i)).first

def solve(days)
  fish = Array.new(9, 0_i64)
  INPUT.each { |i| fish[i] += 1_i64 }
  days.times do |_|
    newfish = Array.new(9, 0_i64)
    fish.each_with_index do |fishes, index|
      if index == 0
        newfish[6] += fishes
        newfish[8] += fishes
      else
        newfish[index - 1] += fishes
      end
    end
    fish = newfish
  end
  fish.sum
end

def part1
  solve 80
end

def part2
  solve 256
end

puts part1, part2
