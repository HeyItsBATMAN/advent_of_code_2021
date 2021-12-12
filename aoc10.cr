DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read_lines("#{DAY}.txt")

BRACKETS = {'[' => ']', '{' => '}', '(' => ')', '<' => '>'}

def part1
  score = {')' => 3, ']' => 57, '}' => 1197, '>' => 25137}
  INPUT.sum { |line|
    expected = Array(Char).new
    first_wrong = line.chars.find { |char|
      if BRACKETS.keys.includes? char
        expected << BRACKETS[char]
        next
      end
      needed = expected.pop
      needed == char ? nil : needed
    }
    score[first_wrong]? || 0
  }
end

def part2
  score = {')' => 1, ']' => 2, '}' => 3, '>' => 4}
  scores = INPUT.map { |line|
    expected, valid = Array(Char).new, true
    line.chars.each do |char|
      if BRACKETS.keys.includes? char
        expected << BRACKETS[char]
      else
        needed = expected.pop
        valid = false if needed != char
      end
    end
    valid ? expected.reverse.reduce(0_i64) { |acc, val| (acc * 5) + score[val] } : 0
  }.sort.reject { |v| v == 0 }
  scores[scores.size // 2]
end

puts part1, part2
