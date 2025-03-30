-- lambda.lua


require"lib.defs"
local reduce = require"lib.eval"
local stringify = require"lib.fmt"


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
			local nextExpr, reduced = reduce(expr, handedness)
			if not reduced or i > 1200 then
				break
			end
			i = i + 1
			print(stringify(expr, "\\", true, false, true))
			table.insert(hist, expr)
			expr = nextExpr
		end
		print(stringify(expr, "\\", true, false, true))
		table.insert(hist, expr)
	elseif line == "z" then -- undo
		print(stringify(expr, "\\", true, false, true))
		expr = table.remove(hist) or expr
	elseif line == "h" then -- history
		for i, e in ipairs(hist) do
			print(i..": "..stringify(e, "\\", true, false, true))
		end
	elseif line:match"^p" then -- print
		local lambda = line:sub(2, 2)
		local color = line:sub(3, 3) == "t"
		local group = line:sub(4, 4) == "t"
		local numbers = line:sub(5, 5) == "t"
		print(stringify(expr, lambda, color, group, numbers))
	elseif line:match"^=" then -- set expression
		local code = ("return(%s)"):format(line:sub(2))
		expr = load(code)()
		hist = {}
		print(stringify(expr, "\\", true, false, true))
	elseif line:match"^!" then -- execute
		load(line:sub(2))()
	else                    -- reduce once
		local nextExpr, reduced = reduce(expr, handedness)
		print(stringify(expr, "\\", true, false, true))
		if reduced then
			table.insert(hist, expr)
			expr = nextExpr
		end
	end
end
