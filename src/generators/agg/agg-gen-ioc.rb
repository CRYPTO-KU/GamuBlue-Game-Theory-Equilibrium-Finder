#!/usr/bin/env ruby

require "optimist"

################################################################################
# Commmandline Arguments
################################################################################

# Parse commandline arguments
opts = Optimist::options do
  synopsis "Generate AGG instances of the Incentivized Outsourced Computation game"
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
# Main
################################################################################

LAZY     = 0
DILIGENT = 1
S        = 2 # Number of action nodes
P        = 0 # Number of function nodes

puts "#AGG"
puts "# More info about the .agg file-format at:"
puts "# https://gambitproject.readthedocs.io/en/latest/formats.html#the-action-graph-game-agg-file-format"
puts

puts "# Player Count"
puts N
puts

puts "# Action Nodes Count"
puts S
puts

puts "# Function Nodes Count"
puts P
puts

puts "# Player Action Set Sizes"
puts ([S] * N).join " "
puts

puts "# Action Sets"
puts (["#{LAZY} #{DILIGENT}"] * N).join "\n"
puts

puts "# Action Graph (Neighbor List Format)"
puts (["#{S} #{LAZY} #{DILIGENT}"] * S).join "\n"
puts

puts "# Function Signatures"
puts "# N/A"
puts

puts "# Payoff Functions"

puts "# Lazy (0)"
puts 0 # Complete Representation
puts (1..N).map { |lazy|
  k = lazy - 1
  if lazy == 1
    R * Q - (F + (B * (N - 1))) * (1 - Q) - COST_Q
  elsif lazy == N
    R - COST_Q
  else
    R * Q - (F + (B * (N - k - 1) / (k + 1))) * (1 - Q) - COST_Q
  end
}.join " "

puts "# Diligent (1)"
puts 0 # Complete Representation
puts (1..N).map { |lazy|
  diligent = N - lazy
  if diligent == N
    R - COST_1
  else
    R + B * (1 - Q) - COST_1
  end
}.join " "
