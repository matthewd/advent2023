ARGV.unshift(__FILE__.sub(/\.rb$/, ".input")) if ARGV.empty? && $stdin.tty?

CARDS = "  23456789TJQKA"

hands = ARGF.readlines(chomp: true).map do |line|
  cards, bid = line.split
  hand = cards.chars.map { |c| CARDS.index(c) }
  [hand, bid.to_i]
end

def type(counts)
  counts.values.sort.reverse
end

ranked_hands = hands.map do |hand, bid|
  [type(hand.tally), hand, bid]
end.sort

winnings = ranked_hands.map.with_index(1) do |(_type, _hand, bid), rank|
  bid * rank
end

p winnings.sum

def wild(counts)
  if wilds = counts.delete(0)
    if n = counts.values.max
      best = counts.key(n)
      counts[best] += wilds
    else
      counts[0] = wilds
    end
  end
  counts
end

hands_wild = hands.map { |hand, bid| [hand.map { |v| v == 11 ? 0 : v }, bid] }

ranked_hands = hands_wild.map do |hand, bid|
  [type(wild(hand.tally)), hand, bid]
end.sort

winnings = ranked_hands.map.with_index(1) do |(_type, _hand, bid), rank|
  bid * rank
end

p winnings.sum
