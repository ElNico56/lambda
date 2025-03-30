-- defs.lua


local function _num(n)
	if n == 0 then
		return 1
	end
	return {2, _num(n - 1)}
end


function N(n)
	return {{_num(n)}}
end

function L(a, b)
	if b then
		return {{a, b}}
	end
	return {a}
end

-- Combinator Birds

M   = L(1, 1)                 -- Mockingbird
S   = L(L(L({3, 1}, {2, 1}))) -- Starling
K   = L(L(2))                 -- Kestrel
KI  = L(L(1))                 -- Kite
I   = L(1)                    -- Idiot
O   = L(L(1, {2, 1}))         -- Owl
Y   = L(L(2, {1, 1}), L(2, {1, 1}))

-- M   = {{1, 1}}               -- Mockingbird
-- S   = {{{{{3, 1}, {2, 1}}}}} -- Starling
-- K   = {{2}}                  -- Kestrel
-- KI  = {{1}}                  -- Kite
-- I   = {1}                    -- Idiot
-- O   = {{{1, {2, 1}}}}        -- Owl
-- Y   = {{{{2, {1, 1}}}, {{2, {1, 1}}}}}

-- Arithmetic

ADD = {{{{{{4, 2}, {{3, 2}, 1}}}}}}
MUL = {{{{3, {2, 1}}}}}
EXP = {{{1, 2}}}

-- Logic

T   = {{2}} -- True
F   = {{1}} -- False
NOT = {{1, {F, T}}}
AND = {{{2, {1, 2}}}}
OR  = {{{1, {2, 1}}}}
IF  = {{{{{3, 2}, 1}}}}
