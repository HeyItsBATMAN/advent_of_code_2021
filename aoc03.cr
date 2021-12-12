DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read_lines("#{DAY}.txt").map(&.chars)
SIZE  = INPUT.first.size

def get_common_in_pos(input, pos) # count occurences in position
  ['0', '1'].map { |c| input.count { |l| l[pos] == c } }
end

def get_common(input) # get pair of '0' and '1' counts
  Array(Int32).new(SIZE, 0).map_with_index { |_, i| get_common_in_pos(input, i) }
end

def part1 # get most common, swap to get least common and return the product
  gamma = get_common(INPUT).join { |t| t.first > t.last ? 0 : 1 }
  epsilon = gamma.tr("01", "10")
  [epsilon, gamma].product(&.to_i(2))
end

def part2
  [['1', '0'], ['0', '1']].product { |order|
    input = INPUT.clone
    (0...SIZE).each do |i| # for each position, eliminate invalid
      zeros, ones = get_common_in_pos(input, i)
      input.select! { |line| line[i] == (ones >= zeros ? order[0] : order[1]) }
      break if input.size == 1
    end
    input.first.join.to_i(2)
  }
end

puts part1, part2
