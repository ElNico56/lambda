-- fmt.lua


local max, min, abs = math.max, math.min, math.abs
local floor, log = math.floor, math.log
local char, byte = string.char, string.byte


local function hsvANSI(h, s, v)
	if h ~= h then h = 0 end
	h = h * 6
	local r = (1 + s * (min(max(abs((h + 0) % 6 - 3) - 1, 0), 1) - 1)) * v
	local g = (1 + s * (min(max(abs((h + 4) % 6 - 3) - 1, 0), 1) - 1)) * v
	local b = (1 + s * (min(max(abs((h + 2) % 6 - 3) - 1, 0), 1) - 1)) * v

	r, g, b = math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
	return ("\x1b[38;2;%d;%d;%dm"):format(r, g, b)
end


local function intPart(x)
	local b = 2 ^ floor(log(x, 2))
	local b1 = 2 ^ floor(log(x, 2) + 1)
	local ret = (1 / b1 + x % b / b)
	return ret
end


local function _str(expr, depth)
	if not expr then return "NIL" end
	if depth > 20 then return "!!!" end
	if type(expr) == "table" then
		if #expr == 1 then
			local v = char(depth % 26 + 97)
			local a = _str(expr[1], depth + 1)
			if a:match"^%b()$" then a = a:sub(2, -2) end
			return ('(\xff%s.%s)'):format(v, a)
		end
		local left = _str(expr[1], depth)
		local right = _str(expr[2], depth)
		return ("(%s%s)"):format(left, right)
	else
		return char((depth - expr) % 26 + 97)
	end
end

local function colorLetter(letter)
	local value = byte(letter) - byte"a"
	return hsvANSI(intPart(value), .5, .9)..letter.."\x1b[0m"
	-- return hsvANSI(value / 12, .5, .9)..letter.."\x1b[0m"
end

---@param expr table|number @expression to stringify
---@param lambda string|nil @prefix for abstractions
---@param group boolean|nil @whether to group abstraction variables
---@param color boolean|nil @whether to colorize the output
---@return string
local function stringify(expr, lambda, group, color)
	lambda = lambda or "@"
	local str = _str(expr, 0)
	if str:match"^%b()$" then str = str:sub(2, -2) end
	while group and str ~= str:gsub("([a-z])%.\xff([a-z])", "%1%2") do
		-- group abstraction variables
		-- \x.\y.\z.e -> \xyz.e
		str = str:gsub("([a-z])%.\xff([a-z])", "%1%2")
	end
	str = str:gsub("\xff", lambda)
	if color then
		return (str:gsub("[a-z]", colorLetter))
	end
	return str
end

return stringify
