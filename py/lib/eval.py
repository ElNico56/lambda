# eval.py


def inc_free(expr, value, depth=0):
    if isinstance(expr, list) and len(expr) == 1:
        # abstraction
        return [inc_free(expr[0], value, depth + 1)]
    elif isinstance(expr, list):
        # application
        left = inc_free(expr[0], value, depth)
        right = inc_free(expr[1], value, depth)
        return [left, right]
    else:
        # variable
        if expr > depth: return expr + value - 1
        return expr


def substitute(expr, value, depth=None):
    if isinstance(expr, list) and len(expr) == 1:
        # abstraction
        if depth is not None:
            return [substitute(expr[0], value, depth + 1)]
        else:
            return substitute(expr[0], value, 1)
    elif isinstance(expr, list):
        # application
        left = substitute(expr[0], value, depth)
        right = substitute(expr[1], value, depth)
        return [left, right]
    else:
        # variable
        if expr == depth: return inc_free(value, depth)
        if expr > depth: return expr - 1
        return expr


def reduce(expr, handedness):
    if isinstance(expr, list) and len(expr) == 1:
        # abstraction
        res, s = reduce(expr[0], handedness)
        return [res], s
    elif isinstance(expr, list):
        # application
        if isinstance(expr[0], list) and len(expr[0]) == 1:
            return substitute(expr[0], expr[1]), True
        if handedness:
            v, s = reduce(expr[1], handedness)
            if s: return [expr[0], v], True
            v, s = reduce(expr[0], handedness)
            if s: return [v, expr[1]], True
        else:
            v, s = reduce(expr[0], handedness)
            if s: return [v, expr[1]], True
            v, s = reduce(expr[1], handedness)
            if s: return [expr[0], v], True
        return expr, False
    else:
        # variable
        return expr, False
