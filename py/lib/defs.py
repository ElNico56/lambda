# defs.py


def _num(n):
    if n < 1:
        return 1
    return [2, _num(n - 1)]


def N(n):
    return [[_num(n)]]


# Combinator Birds

M = [[1, 1]]  # Mockingbird
S = [[[[[3, 1], [2, 1]]]]]  # Starling
K = [[2]]  # Kestrel
KI = [[1]]  # Kite
I = [1]  # Idiot
O = [[[1, [2, 1]]]]  # Owl
Y = [[[[2, [1, 1]]], [[2, [1, 1]]]]]

# Arithmetic

SUCC = [[[[2, [[3, 2], 1]]]]]
ADD = [[[[[[4, 2], [[3, 2], 1]]]]]]
MUL = [[[[3, [2, 1]]]]]
EXP = [[[1, 2]]]

# Logic

T = [[2]]  # True
F = [[1]]  # False
NOT = [[[1, F], T]]
AND = [[[[2, 1], 2]]]
OR = [[[[2, 2], 1]]]
IF = [[[[[3, 2], 1]]]]
