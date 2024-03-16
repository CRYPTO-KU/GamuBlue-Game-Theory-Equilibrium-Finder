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
    prog = "t-immunity",
    description = "Compute t-immunity for a normal-form (NFG) game.",
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

for t in range(1, n + 1):
    for T in arbitrary(g.players, t):
        remaining = [p for p in g.players if p not in T]
        for s_T in group_strategies(T):
            s_N_prime = pure_strategy_profile_prime(s_N, s_T)

            if any(map(lambda p : s_N_prime.payoff(p) < s_N.payoff(p), remaining)):
                print(t - 1)
                exit()

print(n)
