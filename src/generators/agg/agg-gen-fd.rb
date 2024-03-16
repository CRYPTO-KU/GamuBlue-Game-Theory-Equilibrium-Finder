#!/usr/bin/env ruby

require "optimist"

################################################################################
# Commmandline Arguments
################################################################################

# Parse commandline arguments
opts = Optimist::options do
  synopsis "Generate AGG instances of the Forwarding Dilemma game"
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
# Main
################################################################################

DROP    = 0
FORWARD = 1
S       = 2 # Number of action nodes
P       = 0 # Number of function nodes

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
puts (["#{DROP} #{FORWARD}"] * N).join "\n"
puts

puts "# Action Graph (Neighbor List Format)"
puts (["#{S} #{DROP} #{FORWARD}"] * S).join "\n"
puts

puts "# Function Signatures"
puts "# N/A"
puts

puts "# Payoff Functions"

puts "# Drop (0)"
puts 0 # Complete Representation
puts (1..N).map { |drop|
  all_drop = drop == N
  all_drop ? 0 : G
}.join " "

puts "# Forward (1)"
puts 0 # Complete Representation
puts ([G - C] * N).join " "
