
ARGV.unshift(__FILE__.sub(/\.rb$/, ".input")) if ARGV.empty? && $stdin.tty?
lines = ARGF.readlines(chomp: true)

values = lines.map { |line|
  digits = line.chars.grep(/[0-9]/)
  (digits.first + digits.last) rescue "0"
}.map(&:to_i)

p values.sum

words = %w(one two three four five six seven eight nine)
numbers = words.map.with_index { |word, index| [word, index + 1] }.to_h
(0..9).each { |i| numbers[i.to_s] = i }

search = Regexp.union(numbers.keys)

values = lines.map { |line|
  first_number = line.match(search).to_s
  last_number = (line.rindex(search); $&) # cool and normal

  first_digit = numbers[first_number]
  last_digit = numbers[last_number]

  first_digit * 10 + last_digit
}

p values.sum

