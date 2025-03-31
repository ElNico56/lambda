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

local nums = {}
local aliases = {}

local function _tonum(str)
	for i, n in pairs(nums) do
		if str == n then
			return "#"..i
		end
	end
	return false
end

local function _toalias(str)
	for s, v in pairs(aliases) do
		if str == s then
			return v
		end
	end
	return false
end

local function _str(expr, depth, alias)
	if not expr then return "NIL" end
	if depth > 20 then return "!!!" end
	if type(expr) == "table" then
		if #expr == 1 then
			local v = char(depth % 26 + 97)
			local a = _str(expr[1], depth + 1, alias)
			if a:match"^%b()$" then a = a:sub(2, -2) end
			local ret = ('(\xff%s.%s)'):format(v, a)
			ret = alias and _tonum(_str(expr, 0, false)) or ret
			ret = alias and _toalias(_str(expr, 0, false)) or ret
			return ret
		end
		local left = _str(expr[1], depth, alias)
		local right = _str(expr[2], depth, alias)
		left = alias and _tonum(_str(expr[1], 0, false)) or left
		right = alias and _tonum(_str(expr[2], 0, false)) or right
		left = alias and _toalias(_str(expr[1], 0, false)) or left
		right = alias and _toalias(_str(expr[2], 0, false)) or right
		return ("(%s%s)"):format(left, right)
	else
		return char((depth - expr) % 26 + 97)
	end
end

aliases[_str(T, 0, false)] = "T"
aliases[_str(F, 0, false)] = "F"
for i = 1, 100 do
	nums[i] = _str(N(i), 0, false)
end

local function colorLetter(letter)
	local value = byte(letter) - byte"a"
	return hsvANSI(intPart(value), .5, .9)..letter.."\x1b[0m"
end

local function colorNumber(num)
	return hsvANSI(intPart(tonumber(num:sub(2))), .5, .9)..num.."\x1b[0m"
end

local function colorAlias(alias)
	if alias == "T" then
		return hsvANSI(.33, .8, .9)..alias.."\x1b[0m"
	elseif alias == "F" then
		return hsvANSI(.00, .8, .9)..alias.."\x1b[0m"
	else
		return hsvANSI(0, 0, 1)..alias.."\x1b[0m"
	end
end

---@param expr table|number @expression to stringify
---@param lambda string|nil @prefix for abstractions
---@param color boolean|nil @whether to colorize the output
---@param group boolean|nil @whether to group abstraction variables
---@param alias boolean|nil @whether to detect church numerals
---@return string
local function stringify(expr, lambda, color, group, alias)
	lambda = lambda or "@"
	local str = _str(expr, 0, alias)
	if str:match"^%b()$" then str = str:sub(2, -2) end
	while group and str ~= str:gsub("([a-z])%.\xff([a-z])", "%1%2") do
		-- group abstraction variables
		-- \x.\y.\z.e -> \xyz.e
		str = str:gsub("([a-z])%.\xff([a-z])", "%1%2")
	end
	str = str:gsub("\xff", lambda)
	if color then
		str = str:gsub("%l", colorLetter)
		str = str:gsub("#%d+", colorNumber)
		for _, pattern in pairs(aliases) do
			str = str:gsub(pattern, colorAlias)
		end
		return str
	end
	return str
end

return stringify
