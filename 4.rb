ARGV.unshift(__FILE__.sub(/\.rb$/, ".input")) if ARGV.empty? && $stdin.tty?
lines = ARGF.readlines(chomp: true)

cards = lines.map do |line|
  _, winners, own = line.split(/: | \| /)
  [winners.split, own.split]
end

points = cards.map { |winners, own|
  matches = (winners & own).size
  if matches > 0
    2 ** (matches.size - 1)
  else
    0
  end
}

p points.sum

card_counts = [1] * lines.size

cards.each_with_index do |(winners, own), idx|
  matches = (winners & own).size

  matches.times do |i|
    card_counts[idx + i + 1] += card_counts[idx]
  end
end

p card_counts.sum
