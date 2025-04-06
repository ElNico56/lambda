# fmt.py

import math
from .defs import N, T, F


def hsv_ansi(h, s, v):
    h *= 6

    def channel(offset):
        return (1 + s * (min(max(abs((h + offset) % 6 - 3) - 1, 0), 1) - 1)) * v

    r = math.floor(channel(0) * 255)
    g = math.floor(channel(4) * 255)
    b = math.floor(channel(2) * 255)
    return f"\x1b[38;2;{r};{g};{b}m"


def int_part(x):
    try:
        b = 2 ** math.floor(math.log(x, 2))
        b1 = 2 ** math.floor(math.log(x, 2) + 1)
    except ValueError:
        return 0
    return 1 / b1 + x % b / b


nums = {}
aliases = {}


def _tonum(string):
    for i, n in nums.items():
        if string == n:
            return f"#{i}"
    return False


def _toalias(string):
    for s, v in aliases.items():
        if string == s:
            return v
    return False


def _str(expr, depth=0, alias=True):
    if expr is None:
        return "NIL"
    if depth > 20:
        return "!!!"
    if isinstance(expr, list):
        if len(expr) == 1:
            v = chr(depth % 26 + 97)
            a = _str(expr[0], depth + 1, alias)
            ret = f"(\xff{v}.{a})"
            if alias:
                alt = _str(expr, 0, False)
                ret = _tonum(alt) or _toalias(alt) or ret
            return ret
        else:
            left = _str(expr[0], depth, alias)
            right = _str(expr[1], depth, alias)
            if alias:
                left_alt = _str(expr[0], 0, False)
                right_alt = _str(expr[1], 0, False)
                left = _tonum(left_alt) or _toalias(left_alt) or left
                right = _tonum(right_alt) or _toalias(right_alt) or right
            return f"({left}{right})"
    else:
        return chr((depth - expr) % 26 + 97)


aliases[_str(T, 0, False)] = "T"
aliases[_str(F, 0, False)] = "F"
for i in range(1, 101):
    nums[i] = _str(N(i), 0, False)


def color_letter(letter):
    value = ord(letter) - ord("a")
    return f"{hsv_ansi(int_part(value), 0.5, 0.9)}{letter}\x1b[0m"


def color_number(num):
    value = int(num[1:])
    return f"{hsv_ansi(int_part(value), 0.5, 0.9)}{num}\x1b[0m"


def color_alias(alias):
    if alias == "T":
        return f"{hsv_ansi(0.33, 0.8, 0.9)}{alias}\x1b[0m"
    elif alias == "F":
        return f"{hsv_ansi(0.00, 0.8, 0.9)}{alias}\x1b[0m"
    else:
        return f"{hsv_ansi(0, 0, 1)}{alias}\x1b[0m"


def stringify(expr: list | int, lambda_char="λ", color=False, group=False, alias=False):
    string = _str(expr, 0, alias)
    if group:
        import re

        pattern = r"([a-z])\.\xff([a-z])"
        while re.search(pattern, string):
            string = re.sub(pattern, r"\1\2", string)
    string = string.replace("\xff", lambda_char)
    if color:
        import re

        string = re.sub(r"[a-z]", lambda m: color_letter(m.group(0)), string)
        string = re.sub(r"#\d+", lambda m: color_number(m.group(0)), string)
        for pattern in aliases.values():
            string = string.replace(pattern, color_alias(pattern))
        return string
    return string
