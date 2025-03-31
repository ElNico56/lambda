-- lambda.lua


require"lib.defs"
local reduce = require"lib.eval"
local stringify = require"lib.fmt"


local expr
expr = {{S, K}, K}
local hist = {}


-- Main game loop
local handedness = true
local lambda = "\\"
local color = true
local group = false
local numbers = true
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
			if stringify(expr) == stringify(nextExpr) then
				break
			end
			i = i + 1
			print(stringify(expr, lambda, color, group, numbers))
			table.insert(hist, expr)
			expr = nextExpr
		end
		print(stringify(expr, lambda, color, group, numbers))
		table.insert(hist, expr)
	elseif line == "z" then -- undo
		print(stringify(expr, lambda, color, group, numbers))
		expr = table.remove(hist) or expr
	elseif line == "h" then -- history
		for i, e in ipairs(hist) do
			print(i..": "..stringify(e, lambda, color, group, numbers))
		end
	elseif line:match"^c" then -- config
		lambda = line:sub(2, 2) == " " and "" or line:sub(2, 2)
		color = line:sub(3, 3) == "t"
		group = line:sub(4, 4) == "t"
		numbers = line:sub(5, 5) == "t"
		print(stringify(expr, lambda, color, group, numbers))
	elseif line:match"^=" then -- set expression
		local code = ("return(%s)"):format(line:sub(2))
		expr = load(code)()
		hist = {}
		print(stringify(expr, lambda, color, group, numbers))
	elseif line:match"^!" then -- execute
		load(line:sub(2))()
	else                    -- reduce once
		local nextExpr, reduced = reduce(expr, handedness)
		print(stringify(expr, lambda, color, group, numbers))
		if reduced then
			table.insert(hist, expr)
			expr = nextExpr
		end
	end
end
