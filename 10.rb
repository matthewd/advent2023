ARGV.unshift(__FILE__.sub(/\.rb$/, ".input")) if ARGV.empty? && $stdin.tty?

grid = {}
ARGF.readlines(chomp: true).each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    grid[[x, y]] = c
  end
end

PIPES = {
  "|" => ["N", "S"],
  "-" => ["E", "W"],
  "J" => ["N", "W"],
  "7" => ["S", "W"],
  "L" => ["N", "E"],
  "F" => ["S", "E"],
}

INVERSE = {
  "N" => "S",
  "S" => "N",
  "E" => "W",
  "W" => "E",
}

def move((x, y), direction)
  case direction
  when "N"; [x, y - 1]
  when "S"; [x, y + 1]
  when "E"; [x + 1, y]
  when "W"; [x - 1, y]
  end
end

def traverse(grid, location, direction)
  if direction
    new_direction = (PIPES[grid[location]] - [INVERSE[direction]]).first

    [move(location, new_direction), new_direction]
  else
    %w(N S E W).map { |d| [move(location, d), d] }.find do |l, d|
      grid[l] && PIPES[grid[l]].include?(INVERSE[d])
    end
  end
end

start = grid.key("S")
path = [[start, nil]]

until path.last.first == start && path.size > 1
  path << traverse(grid, *path.last)
end

p path.size / 2


path[0][1] = path[-1][1]

joint = [INVERSE[path[0][1]], path[1][1]]
grid[start] = PIPES.key(joint) || PIPES.key(joint.reverse)

LEFT = {
  "N" => "W",
  "S" => "E",
  "E" => "N",
  "W" => "S",
}

outside = path.each_cons(2).flat_map do |(location, entry_direction), (_, exit_direction)|
  [entry_direction, exit_direction].uniq.map do |d|
    move(location, LEFT[d])
  end.select { |l| grid[l] }
end

require "set"

pipes = path.map(&:first)
seen = Set.new(pipes | outside)

outside -= pipes
outside.uniq!

frontier = outside

until frontier.empty?
  frontier = frontier.flat_map do |(x, y)|
    [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].select do |loc|
      grid[loc] && seen.add?(loc)
    end
  end

  outside |= frontier
end

inside = grid.keys - seen.to_a

inside = outside if inside.any? { |x, y| x == 0 || y == 0 }

p inside.size
