ARGV.unshift(__FILE__.sub(/\.rb$/, ".input")) if ARGV.empty? && $stdin.tty?
rows = ARGF.readlines(chomp: true).map { |s| s.split.map(&:to_i) }

rows.each do |row|
  stack = [row]

  until stack.last.all?(&:zero?)
    stack << stack.last.each_cons(2).map { _2 - _1 }
  end

  stack.reverse.each_cons(2) do |a, b|
    b << b.last + a.last

    b.unshift b.first - a.first
  end
end

p rows.sum(&:last)
p rows.sum(&:first)
