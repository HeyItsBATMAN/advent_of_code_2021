DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read_lines("#{DAY}.txt").first.chars.map(&.to_i(16).to_s(2).rjust(4, '0')).join.chars

struct Node
  property version : Int32
  property type_id : Int32
  property chunks = Array(Array(Char)).new
  property children = Array(Node).new

  def initialize(@version : Int32, @type_id : Int32)
  end

  def value : Int64
    case @type_id
    when 0 then @children.sum(&.value)                                   # sum
    when 1 then @children.reduce(1_i64) { |acc, val| acc * val.value }   # prod
    when 2 then @children.min_of(&.value)                                # min
    when 3 then @children.max_of(&.value)                                # max
    when 4 then @chunks.map { |c| c.skip(1) }.flatten.join.to_i64(2)     # literal
    when 5 then @children[0].value > @children[1].value ? 1_i64 : 0_i64  # gt
    when 6 then @children[0].value < @children[1].value ? 1_i64 : 0_i64  # lt
    when 7 then @children[0].value == @children[1].value ? 1_i64 : 0_i64 # eq
    else        0_i64
    end
  end

  def version_sum : Int32
    @version + @children.sum(&.version_sum)
  end
end

def take(pos, amount)
  return {pos + amount, INPUT[pos...pos + amount]}
end

def node(pos)
  pos, version = take(pos, 3)
  pos, type_id = take(pos, 3)
  current = Node.new(version.join.to_i(2), type_id.join.to_i(2))
  case type_id.join.to_i(2)
  when 4 # parse literal value
    chunks = Array(Array(Char)).new
    loop do
      pos, chunk = take(pos, 5)
      chunks << chunk
      break if chunk.first == '0'
    end
    current.chunks = chunks
  else # parse with operator mode
    pos, mode = take(pos, 1)
    case mode.first.to_i
    when 0
      pos, length = take(pos, 15)
      start = pos
      while pos < start + length.join.to_i(2)
        pos, child = node(pos)
        current.children << child
      end
    when 1
      pos, subpackets = take(pos, 11)
      subpackets.join.to_i(2).times do
        pos, child = node(pos)
        current.children << child
      end
    end
  end
  return {pos, current}
end

def part1
  node(0).last.version_sum
end

def part2
  node(0).last.value
end

puts part1, part2
