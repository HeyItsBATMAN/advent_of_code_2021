DAY   = PROGRAM_NAME.match(/aoc\d{2}/).not_nil![0]
INPUT = File.read_lines("#{DAY}.txt").map(&.split("-").map(&.strip))
CAVE  = INPUT.flatten.uniq.to_h { |key| {key, Set(String).new} }

INPUT.each { |line| CAVE[line.first] << line.last }
CAVE.each { |from, to| to.each { |start| CAVE[start] << from } }

def part1
  queue, paths = [{"start", ["start"], Set(String).new}], Set(Array(String)).new
  until queue.empty?
    from, path, visited_small = queue.pop
    if from == "end"
      paths << path
      next
    end
    CAVE[from].reject { |o| o == "start" }.each do |other|
      next if visited_small.includes?(other) if other.downcase == other
      queue << {other, path.clone.push(other), visited_small.clone.add(other)}
    end
  end
  paths.size
end

def part2
  queue, paths = [{"start", ["start"], Hash(String, Int32).new { 0 }}], Set(Array(String)).new
  until queue.empty?
    from, path, visited_small = queue.pop
    if from == "end"
      paths << path
      next
    end
    CAVE[from].reject { |o| o == "start" }.each do |other|
      next if visited_small[other] >= 1 && visited_small.any? { |_, v| v == 2 }
      clone = visited_small.clone
      clone[other] += 1 if other.downcase == other
      queue << {other, path.clone.push(other), clone}
    end
  end
  paths.size
end

puts part1, part2
