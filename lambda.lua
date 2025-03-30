-- lambda.lua


local reduce = require"lib.eval"
local stringify = require"lib.fmt"
require"lib.defs"


local expr
expr = {{S, K}, K}
local hist = {}


-- Main game loop
local handedness = true
while true do -- REPL loop
	io.write":"
	local line = io.read()
	if line == "q" then  -- quit
		break
	elseif line == "f" then -- flip
		handedness = not handedness
		print("Handedness: "..(handedness and "right" or "left"))
	elseif line == "r" then -- reduce all
		local i = 0
		while true do
			local nextexpr, reduced = reduce(expr, handedness)
			if not reduced or i > 1200 then
				break
			end
			i = i + 1
			print(stringify(expr, "\\", false, true))
			table.insert(hist, expr)
			expr = nextexpr
		end
		print(stringify(expr, "\\", false, true))
		table.insert(hist, expr)
	elseif line == "z" then -- undo
		print(stringify(expr, "\\", false, true))
		expr = table.remove(hist) or expr
	elseif line == "h" then -- history
		for i, e in ipairs(hist) do
			print(i..": "..stringify(e, "\\", false, true))
		end
	elseif line:match"^p" then -- print
		print(stringify(expr, line:sub(2), false, true))
	elseif line:match"^=" then -- set expression
		local code = ("return(%s)"):format(line:sub(2))
		expr = load(code)()
		hist = {}
		print(stringify(expr, "\\", false, true))
	elseif line:match"^!" then -- execute
		load(line:sub(2))()
	else                    -- reduce once
		local nextexpr, reduced = reduce(expr, handedness)
		print(stringify(expr, "\\", false, true))
		if reduced then
			table.insert(hist, expr)
			expr = nextexpr
		end
	end
end
