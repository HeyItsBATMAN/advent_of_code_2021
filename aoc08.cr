DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read_lines("#{DAY}.txt").map(&.split(" | ").map(&.split(" ")))

SIZES = {1 => 2, 4 => 4, 7 => 3, 8 => 7}

def part1
  INPUT.sum { |l| SIZES.values.flat_map { |d| l.last.select { |s| s.size == d } }.size }
end

def part2
  INPUT.sum { |line|
    nums, output = line
    mapping, segments = Hash(Int32, Array(Char)).new, Hash(String, Array(Char)).new

    # add known (1,4,7,8) to mappings
    SIZES.each { |d, s| mapping[d] = nums.find { |n| n.size == s }.not_nil!.chars.sort }

    nums_235 = nums.select { |n| n.size == 5 }.map(&.chars)

    # find needed segments
    segments["t"] = mapping[7] - mapping[1]                               # top
    segments["tl-m"] = mapping[4] - mapping[1]                            # top-left & middle
    segments["t-m-b"] = nums_235.reduce { |acc, arr| acc & arr }          # top & middle & bottom
    segments["m"] = segments["tl-m"] & segments["t-m-b"]                  # middle
    segments["tl"] = segments["tl-m"] - segments["m"]                     # top-left
    segments["b"] = segments["t-m-b"] - segments["m"] - segments["t"]     # bottom
    segments["bl"] = mapping[8] - mapping[7] - mapping[4] - segments["b"] # bottom-left

    # complete mappings
    tl, bl = segments["tl"].first, segments["bl"].first
    mapping[9] = mapping[8] - segments["bl"]
    mapping[5] = nums_235.find { |arr| arr.includes?(tl) && !arr.includes?(bl) }.not_nil!
    mapping[3] = nums_235.find { |arr| !arr.includes?(tl) && !arr.includes?(bl) }.not_nil!
    mapping[2] = nums_235.find { |arr| !arr.includes?(tl) && arr.includes?(bl) }.not_nil!
    mapping[0] = mapping[8] - segments["m"]
    mapping[6] = mapping[5] + segments["bl"]

    # reverse mapping and calc
    complete = mapping.map { |k, v| {v.sort.join, k} }.to_h
    output.map { |signal| complete[signal.chars.sort.join] }.join.to_i
  }
end

puts part1, part2
