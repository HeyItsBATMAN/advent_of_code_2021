DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read("#{DAY}.txt").strip.split("\n\n")

record Board, board : Array(Array(Int32)) do
  def is_winner?(seen : Array(Int32))
    [@board, @board.transpose].any?(&.any?(&.all? { |v| seen.includes?(v) }))
  end

  def score(seen : Array(Int32))
    @board.flatten.sum { |v| seen.includes?(v) ? 0 : v }
  end
end

NUMS   = INPUT.first.split(",").map(&.to_i)
BOARDS = INPUT.skip(1).map(&.split("\n")).map { |chunk|
  Board.new(chunk.map(&.split(" ", remove_empty: true).map(&.strip.to_i)))
}

def part1
  NUMS.each_with_index do |n, i|
    seen = NUMS.first(i + 1)
    winner = BOARDS.find { |b| b.is_winner?(seen) }
    return winner.score(seen) * n if winner
  end
end

def part2
  winners = Set(Int32).new
  NUMS.each_with_index do |n, i|
    seen = NUMS.first(i + 1)
    BOARDS.each_with_index do |b, bi|
      next if winners.includes?(bi)
      next if !b.is_winner? seen
      winners << bi
      return b.score(seen) * n if winners.size == BOARDS.size
    end
  end
end

puts part1, part2
