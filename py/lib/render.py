# render.py

import raylib as rl


def compute_size(expr):
    if isinstance(expr, list):
        if len(expr) == 1:
            w, h = compute_size(expr[0])
            return w, h + 2
        else:
            w1, h1 = compute_size(expr[0])
            w2, h2 = compute_size(expr[1])
            return w1 + w2, max(h1, h2) + 2
    else:
        return 4, 1


def render(expr, x, y, scale, color):
    mw, mh = compute_size(expr)
    if isinstance(expr, list):
        if len(expr) == 1:
            _, h = compute_size(expr[0])
            render(expr[0], x, y + mh - h - 2, scale, color)
            rl.DrawRectangle(
                x * scale,
                (y + mh - 1) * scale,
                (mw - 1) * scale,
                scale,
                color,
            )
        else:
            w1, h1 = compute_size(expr[0])
            w2, h2 = compute_size(expr[1])
            render(expr[0], x, y + mh - h1, scale, color)
            render(expr[1], x + w1, y + mh - h2, scale, color)

            rl.DrawRectangle(
                (x + 1) * scale,
                y * scale,
                scale,
                (mh - h1) * scale,
                color,
            )
            rl.DrawRectangle(
                (x + 1) * scale,
                (y + 2) * scale,
                (mw - w2) * scale,
                scale,
                color,
            )
            rl.DrawRectangle(
                (x + 1 + w1) * scale,
                (y + 2) * scale,
                scale,
                (mh - h2 - 1) * scale,
                color,
            )
    else:
        rl.DrawRectangle(
            (x + 1) * scale,
            y * scale,
            scale,
            2 * expr * scale,
            color,
        )

    # Optional debug features from Lua version:
    # rl.DrawText(str(expr), x * scale, y * scale, 30, color)
    # rl.DrawRectangleLines(x * scale, y * scale,
    #                      mw * scale, mh * scale, color)
