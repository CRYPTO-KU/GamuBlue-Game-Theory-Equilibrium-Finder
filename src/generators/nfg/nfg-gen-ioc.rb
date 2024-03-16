#!/usr/bin/env ruby

require "optimist"

################################################################################
# Commmandline Arguments
################################################################################

# Parse commandline arguments
opts = Optimist::options do
  synopsis "Generate NFG instances of the Incentivized Outsourced Computation game"
  opt :players, "Number of players",                  :short => :N, :type => :int,   :required => true
  opt :cost_1,  "Diligent algorithm cost",            :short => :d, :type => :float, :default  => 10.0
  opt :cost_q,  "Lazy algorithm cost",                :short => :l, :type => :float, :default  => 5.0
  opt :q,       "Lazy algorithm correct probability", :short => :q, :type => :float, :default  => 0.5
  opt :reward,  "Reward amount",                      :short => :r, :type => :float, :default  => 20.0
  opt :bounty,  "Bounty amount [default = reward]",   :short => :b, :type => :float, :required => false
  opt :fine,    "Fixed fine amount",                  :short => :f, :type => :float, :default  => 2.5
end

# Parse parameters
N      = opts[:players]
COST_1 = opts[:cost_1]
COST_Q = opts[:cost_q]
Q      = opts[:q]
R      = opts[:reward]
B      = opts[:bounty] || R
F      = opts[:fine]

# Validate inputs
Optimist::die :players, "should be more than two"     if N < 2
Optimist::die :cost_1,  "should be positive"          if COST_1 <= 0
Optimist::die :cost_q,  "should be positive"          if COST_Q <= 0
Optimist::die :reward,  "should be positive"          if R <= 0
Optimist::die :cost_1,  "should be less than reward"  if COST_1 >= R
Optimist::die :cost_q,  "should be less than cost(1)" if COST_Q >= COST_1
Optimist::die :q,       "should be in [0, 1)"         if Q < 0 || Q >= 1
Optimist::die :bounty,  "cannot be negative"          if B < 0
Optimist::die :fine,    "cannot be negative"          if F < 0

# Print parsed parameters
STDERR.puts
STDERR.puts "Player Count (N) : #{N}"
STDERR.puts "cost(1)          : #{COST_1}"
STDERR.puts "cost(q)          : #{COST_Q}"
STDERR.puts "q                : #{Q}"
STDERR.puts "Reward           : #{R}"
STDERR.puts "Bounty           : #{B}"
STDERR.puts "Fixed Fine       : #{F}"
STDERR.puts

################################################################################
# Helper Functions
################################################################################

def popcount(n)
  count = 0
  while n > 0
    n &= n - 1
    count += 1
  end
  return count
end

################################################################################
# Main
################################################################################

LAZY     = 0
DILIGENT = 1

# Header
puts 'NFG 1 R "Incentivized Outsourced Computation"'

puts

# Player Set
puts "{"
N.times do |i|
  puts "  \"Contractor #{i + 1}\""
end
puts "}"

puts

# Actions Sets
puts "{"
N.times do
  puts '  { "Lazy" "Diligent" }'
end
puts "}"

puts

# Payoffs

BEG_STRATEGY_PROFILE = 0
END_STRATEGY_PROFILE = (1 << N) - 1

(BEG_STRATEGY_PROFILE..END_STRATEGY_PROFILE).each do |s_N|
  lazy = N - popcount(s_N)

  (1..N).each do |i|
    strategy     = s_N[i - 1]
    k            = strategy == LAZY ? lazy - 1 : lazy
    all_diligent = k == 0
    all_lazy     = k == N - 1

    if all_diligent and strategy == DILIGENT
      print R - COST_1
    elsif all_diligent and strategy == LAZY
      print R * Q - (F + (B * (N - 1))) * (1 - Q) - COST_Q
    elsif all_lazy and strategy == DILIGENT
      print R + B * (1 - Q) - COST_1
    elsif all_lazy and strategy == LAZY
      print R - COST_Q
    elsif strategy == DILIGENT
      print R + B * (1 - Q) - COST_1
    else
      print R * Q - (F + (B * (N - k - 1) / (k + 1))) * (1 - Q) - COST_Q
    end

    print i != N ? " " : "\n"
  end
end
