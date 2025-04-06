# main.py

import raylib as rl
from lib.defs import *
from lib.eval import reduce
from lib.render import compute_size, render
from lib.fmt import stringify

# Example lambda expression setup
expr = [[EXP, N(3)], N(2)]  # 3 ^ 2
expr = [[ADD, N(3)], N(2)]  # 3 + 2
expr = [[S, K], K]
# expr = [[MUL, N(3)], N(2)]
# expr = [[[2, [1, 1]]]]
# expr = [[[[[[4, 3], 2], 1]]]]
# expr = [[[0, 1], [2, 3]], [[4, 5], [6, 7]]]
# expr = [[[0, -1], [-2, -3]], [[-4, -5], [-6, -7]]]
# expr = [[[[[[0, 1], [2, 3]]]]]]
# expr = [[[[[[0, -1], [-2, -3]]]]]]

hist = []

# Initialization
screen_width = 1280
screen_height = 720

rl.SetConfigFlags(rl.FLAG_VSYNC_HINT | rl.FLAG_WINDOW_RESIZABLE)
rl.SetTraceLogLevel(rl.LOG_WARNING)
rl.InitWindow(screen_width, screen_height, b"Tromp diagram renderer")

handedness = True

while not rl.WindowShouldClose():
    if rl.IsKeyPressed(82):  # 'R' key
        handedness = not handedness
        print("Handedness:", "right" if handedness else "left")

    if rl.IsMouseButtonPressed(rl.MOUSE_BUTTON_LEFT):
        nextexpr, reduced = reduce(expr, handedness)
        print(stringify(expr, "\\", True))
        if reduced:
            hist.append(expr)
            expr = nextexpr

    if rl.IsMouseButtonPressed(rl.MOUSE_BUTTON_RIGHT):
        expr = hist.pop() if hist else expr

    rl.BeginDrawing()
    rl.ClearBackground(rl.BLACK)

    e_w, e_h = compute_size(expr)
    s_w = rl.GetScreenWidth() - 20
    s_h = rl.GetScreenHeight() - 20
    s = min(s_w / e_w, s_h / e_h)

    render(expr, 10, 10, 10, rl.RAYWHITE)
    rl.DrawText(stringify(expr, "L").encode("utf-8"), 10, 10, 30, rl.RAYWHITE)

    rl.EndDrawing()

rl.CloseWindow()
