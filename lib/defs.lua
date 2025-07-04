-- defs.lua


local function _num(n)
	if n < 0 then
		return 1
	end
	return {2, _num(n - 1)}
end


function N(n)
	return {{_num(n)}}
end

-- Combinator Birds

M    = {{1, 1}}                         -- Mockingbird IDK
S    = {{{{{3, 1}, {2, 1}}}}}           -- Starling S combinator
K    = {{2}}                            -- Kestrel True
KI   = {{1}}                            -- Kite False
I    = {1}                              -- Idiot Identity
O    = {{{1, {2, 1}}}}                  -- Owl HUH?
Y    = {{{{2, {1, 1}}}, {{2, {1, 1}}}}} -- Y combinator

-- Arithmetic

SUCC = {{{{2, {{3, 2}, 1}}}}}
ADD  = {{{{{{4, 2}, {{3, 2}, 1}}}}}}
MUL  = {{{{3, {2, 1}}}}}
EXP  = {{{1, 2}}}

-- Logic

T    = {{2}} -- True
F    = {{1}} -- False
NOT  = {{{1, F}, T}}
AND  = {{{{2, 1}, 2}}}
OR   = {{{{2, 2}, 1}}}
IF   = {{{{{3, 2}, 1}}}}
