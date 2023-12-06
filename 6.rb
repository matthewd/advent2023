ARGV.unshift(__FILE__.sub(/\.rb$/, ".input")) if ARGV.empty? && $stdin.tty?
lines = ARGF.readlines(chomp: true)

races = lines.map { |line| line.split(?:).last.split.map(&:to_i) }.transpose

# travel = (duration - hold) * hold

win_conditions = races.map do |duration, target|
  min_hold = (1..duration / 2).bsearch { |hold| (duration - hold) * hold > target }
  overflow_hold = (min_hold..duration - 1).bsearch { |hold| (duration - hold) * hold <= target }

  overflow_hold - min_hold
end

p win_conditions.reduce(:*)

races = [lines.map { |line| line.split(?:).last.delete(" ").to_i }]

win_conditions = races.map do |duration, target|
  min_hold = (1..duration / 2).bsearch { |hold| (duration - hold) * hold > target }
  overflow_hold = (min_hold..duration - 1).bsearch { |hold| (duration - hold) * hold <= target }

  overflow_hold - min_hold
end

p win_conditions.reduce(:*)
