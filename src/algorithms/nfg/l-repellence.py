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
    prog = "l-repellence",
    description = "Compute l-repellence for a normal-form (NFG) game.",
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

for l in range(1, n + 1):
    for C in coalitions(g, l):
        for s_C in group_strategies(C):
            s_N_prime = pure_strategy_profile_prime(s_N, s_C)

            if U_C(C, s_N) < U_C(C, s_N_prime):
                print(l - 1)
                exit()

print(n)
