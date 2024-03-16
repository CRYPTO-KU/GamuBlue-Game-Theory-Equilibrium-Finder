import pygambit

def GameNFG(path):
    g = pygambit.Game.read_game(path)
    if not g.write().startswith("NFG"):
        raise ValueError()
    return g

def validate_strategy_profile(parser, args):
    g   = args.game
    s_N = args.strategy_profile
    if len(s_N) != len(g.players):
        parser.error("The size of the strategy profile should match the number of players.")
    for p in g.players:
        s_p = s_N[p.number]
        if s_p < 0 or s_p >= len(p.strategies):
            parser.error("Invalid strategy index.")
