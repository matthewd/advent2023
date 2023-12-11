ARGV.unshift(__FILE__.sub(/\.rb$/, ".input")) if ARGV.empty? && $stdin.tty?
lines = ARGF.readlines(chomp: true)

galaxies = []

x_weights = [nil] * lines.first.size
y_weights = [nil] * lines.size

lines.each_with_index do |line, y|
  line.scan(/#/) do |match|
    x = Regexp.last_match.begin(0)
    galaxies << [x, y]
    x_weights[x] = 1
    y_weights[y] = 1
  end
end

distances = galaxies.combination(2).map do |(x1, y1), (x2, y2)|
  x_distance = ([x1, x2].min...[x1, x2].max).map { |x| x_weights[x] || 2 }.sum
  y_distance = ([y1, y2].min...[y1, y2].max).map { |y| y_weights[y] || 2 }.sum

  x_distance + y_distance
end

p distances.sum

distances = galaxies.combination(2).map do |(x1, y1), (x2, y2)|
  x_distance = ([x1, x2].min...[x1, x2].max).map { |x| x_weights[x] || 1000000 }.sum
  y_distance = ([y1, y2].min...[y1, y2].max).map { |y| y_weights[y] || 1000000 }.sum

  x_distance + y_distance
end

p distances.sum
