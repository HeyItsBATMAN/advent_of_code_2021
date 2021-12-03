DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read_lines("#{DAY}.txt").map(&.chars)

def get_common_in_pos(input, pos)
  {input.count { |l| l[pos] == '0' }, input.count { |l| l[pos] == '1' }}
end

def get_common(input)
  common = Array(Int32).new(input.first.size, 0)
  common.map_with_index { |_, i| get_common_in_pos(input, i) }
end

def part1
  common = get_common(INPUT.clone)
  gamma = common.map { |t| t.first > t.last ? 0 : 1 }.join
  epsilon = gamma.tr("01", "10")
  return gamma.to_i(2) * epsilon.to_i(2)
end

def part2
  oxy_input, scr_input, size = INPUT.clone, INPUT.clone, INPUT.first.size

  (0...size).each do |i|
    break if oxy_input.size == 1
    zeros, ones = get_common_in_pos(oxy_input, i)
    common = ones >= zeros ? '1' : '0'
    oxy_input.select! { |line| line[i] == common }
  end

  (0...size).each do |i|
    break if scr_input.size == 1
    zeros, ones = get_common_in_pos(scr_input, i)
    common = ones >= zeros ? '0' : '1'
    scr_input.select! { |line| line[i] == common }
  end

  return oxy_input.first.join.to_i(2) * scr_input.first.join.to_i(2)
end

puts part1, part2
