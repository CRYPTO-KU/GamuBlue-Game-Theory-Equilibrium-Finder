#!/usr/bin/env ruby

require "optimist"

################################################################################
# Commmandline Arguments
################################################################################

# Parse commandline arguments
opts = Optimist::options do
  synopsis "Generate NFG instances of the Forwarding Dilemma game"
  opt :players, "Number of players",   :type => :int,   :required => true, :short => :N
  opt :gain,    "Network gain factor", :type => :float, :default  => 2.0
  opt :cost,    "Forwarding cost",     :type => :float, :default  => 1.0
end

# Parse parameters
N = opts[:players]
G = opts[:gain]
C = opts[:cost]

# Validate inputs
Optimist::die :players, "should be more than two"     if N <  2
Optimist::die :gain,    "should be positive"          if G <= 0
Optimist::die :cost,    "should be positive"          if C <= 0
Optimist::die :cost,    "should be less than gain"    if C >= G

# Print parsed parameters
STDERR.puts
STDERR.puts "Player Count (N) : #{N}"
STDERR.puts "Network Gain (G) : #{G}"
STDERR.puts "Forward Cost (C) : #{C}"
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

DROP    = 0
FORWARD = 1

# Header
puts 'NFG 1 R "Forwarding Dilemma"'

puts

# Player Set
puts "{"
N.times do |i|
  puts "  \"Node #{i + 1}\""
end
puts "}"

puts

# Actions Sets
puts "{"
N.times do
  puts '  { "Drop" "Forward" }'
end
puts "}"

puts

# Payoffs

BEG_STRATEGY_PROFILE = 0
END_STRATEGY_PROFILE = (1 << N) - 1

(BEG_STRATEGY_PROFILE..END_STRATEGY_PROFILE).each do |s_N|
  drop = N - popcount(s_N)

  (1..N).each do |i|
    strategy     = s_N[i - 1]
    k            = strategy == DROP ? drop - 1 : drop
    all_drop     = k == N - 1

    if strategy == DROP
      print all_drop ? 0 : G
    else
      print G - C
    end

    print i != N ? " " : "\n"
  end
end
