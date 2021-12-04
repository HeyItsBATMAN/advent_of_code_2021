DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read("#{DAY}.txt").strip.split("\n\n")

record Board, board : Array(Array(Int32)) do
  def initialize(@board)
  end

  def is_winner?(seen : Set(Int32))
    @board.any?(&.all? { |v| seen === v }) || @board.transpose.any?(&.all? { |v| seen === v })
  end

  def score(seen : Set(Int32))
    @board.flatten.map { |v| seen.includes?(v) ? 0 : v }.sum
  end

  forward_missing_to @board
end

NUMS   = INPUT.first.split(",").map(&.to_i)
BOARDS = Array(Board).new

INPUT.skip(1).map(&.split("\n")).each do |chunk|
  BOARDS << Board.new(chunk.map(&.split(" ").reject(&.empty?).map(&.strip.to_i)))
end

def part1
  seen = Set(Int32).new
  NUMS.each do |num|
    seen << num
    winner = BOARDS.find { |b| b.is_winner? (seen) }
    next if !winner
    return winner.score(seen) * seen.to_a.last
  end
end

def part2
  seen, winners = Set(Int32).new, Set(Int32).new
  NUMS.each do |num|
    seen << num
    BOARDS.each_with_index do |b, bi|
      next if winners.includes?(bi)
      next if !b.is_winner? seen
      winners << bi
      next if winners.size != BOARDS.size
      return b.score(seen) * seen.to_a.last
    end
  end
end

puts part1, part2
