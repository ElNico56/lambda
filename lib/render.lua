-- render.lua


local rl = rl ---@diagnostic disable-line undefined-global


local function computeSize(expr)
	if type(expr) == "table" then
		if #expr == 1 then
			local w, h = computeSize(expr[1])
			return w, h + 2
		end
		local w1, h1 = computeSize(expr[1])
		local w2, h2 = computeSize(expr[2])
		return w1 + w2, math.max(h1, h2) + 2
	else
		return 4, 1
	end
end

local function drawSquare(x, y, s, color)
	rl.DrawRectangle(x * s, y * s, s, s, color)
end

---@param expr table|number
---@param x number
---@param y number
---@param scale number
---@param color table
local function render(expr, x, y, scale, color)
	local mw, mh = computeSize(expr)
	if type(expr) == "table" then
		if #expr == 1 then
			local w, h = computeSize(expr[1])
			render(expr[1], x, y + mh - h - 2, scale, color)
			rl.DrawRectangle(
				x * scale, (y + mh - 1) * scale,
				(mw - 1) * scale, scale, color)
		else
			local w1, h1 = computeSize(expr[1])
			local w2, h2 = computeSize(expr[2])
			render(expr[1], x, y + mh - h1, scale, color)
			render(expr[2], x + w1, y + mh - h2, scale, color)

			rl.DrawRectangle(
				(x + 1) * scale, y * scale,
				scale, (mh - h1) * scale, color)
			rl.DrawRectangle(
				(x + 1) * scale, (y + 2) * scale,
				(mw - w2) * scale, scale, color)
			rl.DrawRectangle(
				(x + 1 + w1) * scale, (y + 2) * scale,
				scale, (mh - h2 - 1) * scale, color)
		end
	else
		rl.DrawRectangle(
			(x + 1) * scale, y * scale,
			scale, 2 * expr * scale, color)
	end
	--rl.DrawText(Stringify(expr),
	--	x * scale, y * scale, 30, color)
	--rl.DrawRectangleLines(
	--	x * scale, y * scale,
	--	mw * scale, mh * scale, color)
end

return {computeSize = computeSize, render = render}
