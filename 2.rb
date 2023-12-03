
ARGV.unshift(__FILE__.sub(/\.rb$/, ".input")) if ARGV.empty? && $stdin.tty?
lines = ARGF.readlines(chomp: true)

games = lines.map do |line|
  label, game = line.split(": ")
  rounds = game.split("; ").map do |round|
    round.split(", ").map do |entry|
      n, c = entry.split
      [c.to_sym, n.to_i]
    end.to_h
  end

  [label.split[1].to_i, rounds]
end.to_h

maxes = { red: 12, green: 13, blue: 14 }
possible_games = games.select do |num, rounds|
  rounds.all? do |round|
    round.all? do |color, n|
      n <= maxes[color]
    end
  end
end

game_numbers = possible_games.keys
p game_numbers.sum

powers = games.map do |_, rounds|
  rounds.
    map { |round| round.values_at(:red, :green, :blue) }.
    transpose.
    map { _1.compact.max }.
    reduce(:*)
end

p powers.sum
