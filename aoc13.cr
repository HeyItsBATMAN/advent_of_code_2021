DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read("#{DAY}.txt").split("\n\n")

DOTS = INPUT.first.split("\n", remove_empty: true).map { |line|
  x, y = line.split(",").map(&.to_i)
  {x, y}
}
FOLDS = INPUT.last.split("\n", remove_empty: true).map { |line|
  axis, pos = line.split(" ").last.split("=")
  {axis, pos.to_i}
}

def part1
  paper = DOTS.clone
  is_x, at = {FOLDS.first.first == "x", FOLDS.first.last}
  paper.map { |dot|
    x, y = dot
    if (is_x ? x : y) > at
      {is_x ? at - (x - at) : x, is_x ? y : at - (y - at)}
    else
      dot
    end
  }.uniq.size
end

def part2
  paper = DOTS.clone
  FOLDS.each do |fold|
    is_x, at = {fold.first == "x", fold.last}
    paper = paper.map { |dot|
      x, y = dot
      if (is_x ? x : y) > at
        {is_x ? at - (x - at) : x, is_x ? y : at - (y - at)}
      else
        dot
      end
    }.uniq
  end
  maxx, maxy = paper.max_of(&.first), paper.max_of(&.last)
  String.build { |str| (0..maxy).each { |y| (0..maxx).each { |x|
    str << (paper.includes?({x, y}) ? '▒' : ' ')
  }; str << "\n" } }
end

puts part1, part2
