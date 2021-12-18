DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read_lines("#{DAY}.txt")

def explodable?(line)
  depth = 0
  line.chars.index { |c|
    depth += 1 if c == '['
    depth -= 1 if c == ']'
    c == ']' && depth >= 4
  }
end

def splittable?(line)
  line =~ /\d{2}/
end

def get_pair_brackets(line)
  depth = 0
  closing = line.chars.index { |c|
    depth += 1 if c == '['
    depth -= 1 if c == ']'
    c == ']' && depth >= 4
  }.not_nil!
  opening = line.chars.rindex('[', closing).not_nil!
  return opening, closing
end

def explode(line)
  # get pair
  opening, closing = get_pair_brackets(line)
  left, right = line[opening..closing].tr("[]", "").split(",").map(&.to_i)
  # get right value and add
  if rvi = line.index(/\d+/, closing)
    range = rvi...line.index(/[^\d+]/, rvi).not_nil!
    line = line.sub(range, (line[range].to_i + right).to_s)
  end
  # get left value and add
  if lvi = line.rindex(/\d+/, opening)
    range = lvi...line.index(/[^\d+]/, lvi).not_nil!
    line = line.sub(range, (line[range].to_i + left).to_s)
  end
  # destroy pair and replace with 0
  opening, closing = get_pair_brackets(line)
  line.sub(opening..closing, "0")
end

def split(line)
  index = line.index(/\d{2}/).not_nil!
  range = (index..index + 1)
  num = line[range].to_i
  halved = (num / 2)
  left, right = halved.floor.to_i, halved.ceil.to_i
  line.sub(range, "[#{left},#{right}]")
end

def reduce(line)
  loop do
    if explodable?(line)
      line = explode(line)
    elsif splittable?(line)
      line = split(line)
    else
      break
    end
  end
  line
end

def magnitude(line)
  while opening = line =~ /\[\d+,\d+\]/
    closing = line.index(']', opening).not_nil!
    pair = line[opening..closing].tr("[]", "").split(",").map(&.to_i)
    value = pair[0] * 3 + pair[1] * 2
    line = line.sub(opening..closing, value.to_s)
  end
  line.to_i
end

def part1
  input = INPUT.clone
  until input.size == 1
    chunk = input.shift(2)
    input.unshift(reduce("[#{chunk.first},#{chunk.last}]"))
  end
  magnitude(input.first)
end

def part2
  input = INPUT.clone
  largest = 0
  input.each_permutation(2) do |chunk|
    left, right = chunk
    value = magnitude(reduce("[#{left},#{right}]"))
    largest = value if value > largest
  end
  largest
end

puts part1, part2
