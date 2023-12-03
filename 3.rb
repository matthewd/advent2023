
ARGV.unshift(__FILE__.sub(/\.rb$/, ".input")) if ARGV.empty? && $stdin.tty?
lines = ARGF.readlines(chomp: true)

numbers = []
symbols = []

symbols_per_line = []

lines.each_with_index do |line, i|
  line.scan(/(\d+)/) do
    m = Regexp.last_match
    numbers << { value: m[1].to_i, row: i, col: m.begin(0), col2: m.end(0) - 1 }
  end

  new_symbols = []
  line.scan(/[^.\d]/) do
    m = Regexp.last_match
    new_symbols << { value: m[0], row: i, col: m.begin(0) }
  end

  symbols_per_line << new_symbols
  symbols += new_symbols
end

surrounded_numbers = {}

numbers.each do |number|
  surrounded_numbers[number] =
    ((number[:row] > 0 ? symbols_per_line[number[:row] - 1] : []) +
     symbols_per_line[number[:row]] +
     (symbols_per_line[number[:row] + 1] || [])).
      select do |symbol|
        symbol[:col] >= (number[:col] - 1) && symbol[:col] <= (number[:col2] + 1)
      end
end

p surrounded_numbers.keys.map { |n| n[:value] }.sum

gears = symbols.select { |s| s[:value] == "*" }

gear_ratios = gears.map do |g|
  nearby_numbers = surrounded_numbers.select { |_, s| s.include?(g) }.keys

  if nearby_numbers.size == 2
    nearby_numbers.map { |n| n[:value] }.reduce(:*)
  end
end.compact

p gear_ratios.sum
