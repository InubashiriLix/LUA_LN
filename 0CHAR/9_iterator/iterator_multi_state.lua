-- well, closure's heaven

-- a iterator with multiple state
local function collectionIter(tbl)
	local current = 0
	local final = #tbl
	return function()
		current = current + 1
		if current <= final then
			return current, tbl[current]
		end
	end
end

for index, value in collectionIter({ 1, 2, 3, 4, 5 }) do
	print(index, value)
end

-- NOTE: FAILED
-- if we want to use the stateless iterator to fuck this, a function can be created
-- local function collectionIterStateless(tbl, starter)
-- 	if starter <= #tbl then
-- 		starter = starter + 1
-- 		return starter, tbl[starter]
-- 	end
-- end
--
-- for index, value in collectionIter(), { 1, 2, 3, 4, 5 }, 0 do
-- 	print(index, value)
-- end
-- FAILED
