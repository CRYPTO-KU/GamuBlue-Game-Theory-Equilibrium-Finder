#!/usr/bin/env python3

################################################################################
# Imports
################################################################################

import argparse

from lib.args  import *

from lib.utils import *

################################################################################
# Parse Arguments
################################################################################

parser = argparse.ArgumentParser(
    prog = "m-stability",
    description = "Compute m-stability for a normal-form (NFG) game.",
)
parser.add_argument(
    "game",
    metavar = "game-file",
    type = GameNFG,
    help = "NFG game file-path"
)
parser.add_argument(
    "strategy_profile",
    metavar = "strategy-profile",
    type = int,
    nargs = "+",
    help = "Pure strategy profile to check"
)

args = parser.parse_args()
validate_strategy_profile(parser, args)

################################################################################
# Main
################################################################################

g   = args.game
s_N = pure_strategy_profile(g, args.strategy_profile)
n   = len(g.players)

for m in range(1, n + 1):
    k = n - m + 1
    for P in partitions(g, k):
        for C in P:
            remaining = [p for p in g.players if p not in C]
            for s_minus_C in group_strategies(remaining):
                s_N_prime = pure_strategy_profile_prime(s_N, s_minus_C)
                for s_C in group_strategies(C):
                    s_N_prime_prime = pure_strategy_profile_prime(s_N_prime, s_C)
                    if U_C(C, s_N_prime) < U_C(C, s_N_prime_prime):
                        print(m - 1)
                        exit()

print(n)
