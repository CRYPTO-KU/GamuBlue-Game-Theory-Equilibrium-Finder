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
    prog = "l-t-resistance",
    description = "Compute (l, t)-resistance for a normal-form (NFG) game.",
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

for l in range(1, n):
    done = False
    for C in coalitions(g, l):
        if done: break
        remaining = [p for p in g.players if p not in C]
        for t in range(1, n - l + 1):
            if done: break
            for T in arbitrary(remaining, t):
                if done: break
                for s_T in group_strategies(T):
                    if done: break
                    s_N_prime = pure_strategy_profile_prime(s_N, s_T)
                    for s_C in group_strategies(C):
                        s_N_prime_prime = pure_strategy_profile_prime(s_N_prime, s_C)
                        if U_C(C, s_N_prime) < U_C(C, s_N_prime_prime):
                            if t > 1:
                                print(l, t - 1)
                                done = True
                                break
                            exit()
    if not done:
        print(l, n - l)
