ARGV.unshift(__FILE__.sub(/\.rb$/, ".input")) if ARGV.empty? && $stdin.tty?
content = ARGF.read

maps = {}
progression = {}

initial_seeds = content.lines.first.split(": ").last.split.map(&:to_i)

content.scan(/(.*?)-to-(.*?) map:\s*((?:.+\n)*)/) do
  from, to, rows = $1, $2, $3

  progression[from] = to
  maps[to] = rows.split("\n").map do |row|
    dest_start, src_start, count = row.split.map(&:to_i)
    [src_start, dest_start, count]
  end.sort
end

layer = "seed"
current_values = initial_seeds

while layer = progression[layer]
  map = maps[layer]

  current_values = current_values.map do |n|
    map_entry = map.find { |src_start, _, count| src_start <= n && src_start + count > n }
    if map_entry
      src_start, dest_start, _ = map_entry
      dest_start + (n - src_start)
    else
      n
    end
  end
end

p current_values.min

current_ranges = initial_seeds.each_slice(2).map { |a, b| a..(a + b - 1) }
layer = "seed"

while layer = progression[layer]
  map = maps[layer]

  new_ranges = []
  current_ranges.each do |range|
    map.each do |src_start, dest_start, count|
      next if (src_start + count) < range.begin
      if count >= range.size
        new_ranges << ((range.begin - src_start + dest_start)..(range.end - src_start + dest_start))
        range = nil
        break
      else
        new_ranges << ((range.begin - src_start + dest_start)..(dest_start + count - 1))
        range = (src_start + count)..range.end
      end
    end
    new_ranges << range if range
  end

  current_ranges = new_ranges
end

p current_ranges.map(&:begin).min
