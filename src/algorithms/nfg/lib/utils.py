from itertools      import product
from more_itertools import distinct_combinations, set_partitions

def U_C(C, strategy_profile):
    return sum(map(lambda p : strategy_profile.payoff(p), C))

def coalitions(game, size):
    return distinct_combinations(game.players, size)

def partitions(game, size):
    return set_partitions(game.players, size)

def arbitrary(remaining, size):
    return distinct_combinations(remaining, size)

def pure_strategy_profile(game, actions):
    profile = game.mixed_strategy_profile()
    for player in game.players:
        for strategy in player.strategies:
            profile[strategy] = 1 if actions[player.number] == strategy.number else 0
    return profile

def pure_strategy_profile_prime(pure_profile, strategies_prime):
    profile = pure_profile.copy()
    for strategy_prime in strategies_prime:
        player = strategy_prime.player
        for strategy in player.strategies:
            profile[strategy] = 0
        profile[strategy_prime] = 1
    return profile

def group_strategies(group):
    return product(*[p.strategies for p in group])
