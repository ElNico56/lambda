-- main.lua


local rl = rl ---@diagnostic disable-line undefined-global


local reduce = require"lib.eval"
local render = require"lib.render"
local stringify = require"lib.fmt"
require"lib.defs"


local expr
expr = {{EXP, N(3)}, N(2)} -- 3 ^ 2
expr = {{ADD, N(3)}, N(2)} -- 3 + 2
expr = {{S, K}, K}
--expr = {{MUL, N(3)}, N(2)} -- 3 * 2
--expr = {{{2, {1, 1}}}}
--expr = {{{{{{{4, 3}, 2}, 1}}}}}
--expr = {{{0, 1}, {2, 3}}, {{4, 5}, {6, 7}}}
--expr = {{{0, -1}, {-2, -3}}, {{-4, -5}, {-6, -7}}}
--expr = {{{{{{0, 1}, {2, 3}}}}}}
--expr = {{{{{{0, -1}, {-2, -3}}}}}}
local hist = {}

-- Initialization
local screenWidth = 1280
local screenHeight = 720

rl.SetConfigFlags(rl.FLAG_VSYNC_HINT)
rl.InitWindow(screenWidth, screenHeight, "Tromp diagram renderer")

-- Load bunny texture

-- Main game loop
local handedness = true
while not rl.WindowShouldClose() do
	if rl.IsKeyPressed(82) then
		handedness = not handedness
		print("Handedness: "..(handedness and "right" or "left"))
	end
	if rl.IsMouseButtonPressed(rl.MOUSE_BUTTON_LEFT) then
		local nextexpr, reduced = reduce(expr, handedness)
		print(stringify(expr, "\\", false, true))
		if reduced then
			table.insert(hist, expr)
			expr = nextexpr
		end
	end
	if rl.IsMouseButtonPressed(rl.MOUSE_BUTTON_RIGHT) then
		expr = table.remove(hist) or expr
	end

	rl.BeginDrawing()
	do
		rl.ClearBackground(rl.BLACK)
		local e_w, e_h = render.computeSize(expr)
		local s_w, s_h = rl.GetScreenWidth(), rl.GetScreenHeight()
		s_w, s_h = s_w - 20, s_h - 20
		local s = math.min(s_w / e_w, s_h / e_h)
		-- render.render(expr, 10 / s, -10 / s - e_h, math.floor(s / 2))

		render.render(expr, 0, 10, 5, rl.RAYWHITE)
		rl.DrawText(stringify(expr, "L"), 10, 10, 30, rl.RAYWHITE)
	end
	rl.EndDrawing()
end
rl.CloseWindow()
