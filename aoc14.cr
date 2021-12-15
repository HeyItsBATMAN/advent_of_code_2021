DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read("#{DAY}.txt").split("\n\n")

POLY = INPUT.first.strip
DIRS = INPUT.last.split("\n", remove_empty: true).map(&.split(" -> ")).to_h { |line|
  {line.first, line.first.split("").insert(1, line.last).join}
}

def solve(steps = 10)
  pairs = Hash(String, Int64).new { 0_i64 }
  POLY.chars.each_cons(2) { |pair| pairs[pair.join] += 1 }

  steps.times do |_|
    new_pairs = Hash(String, Int64).new { 0_i64 }
    pairs.each do |from, count|
      to = DIRS[from]
      new_pairs[to[0..1]] += count
      new_pairs[to[1..2]] += count
    end
    pairs = new_pairs
  end

  letters = pairs.keys.join.chars.uniq.to_h { |c|
    {c, pairs.select { |k, _| k[0] == c }.values.sum}
  }
  letters[POLY[-1]] += 1

  min, max = letters.minmax_of(&.last)
  max - min
end

def part1
  solve(10)
end

def part2
  solve(40)
end

puts part1
puts part2
