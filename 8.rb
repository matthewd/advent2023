ARGV.unshift(__FILE__.sub(/\.rb$/, ".input")) if ARGV.empty? && $stdin.tty?
lines = ARGF.readlines(chomp: true)

instructions = lines.shift.chars.map { |c| c == "L" ? 0 : 1 }
lines.shift

N = instructions.size

map = {}
lines.each do |line|
  from, left, right = line.split(/\W+/)
  map[from] = [left, right]
end

n = 0

at = "AAA"
while at != "ZZZ"
  at = map[at][instructions[n % N]]
  n += 1
end

p n

starts = map.keys.grep(/A$/)
ends = map.keys.grep(/Z$/)

cycles = starts.map do |at|
  n = 0
  until ends.include?(at)
    at = map[at][instructions[n % N]]
    n += 1
  end
  n
end

p cycles.reduce(&:lcm)
