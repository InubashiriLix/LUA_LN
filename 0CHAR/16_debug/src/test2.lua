function newCounter()
	local n = 0
	local k = 0
	return function()
		k = n
		n = n + 1
		return n
	end
end

local counter = newCounter()
print(counter())
print(counter())

local i = 1

repeat
	local name, val = debug.getupvalue(counter, i)
	if name then
		print("index", i, name, "=", val)
		if name == "n" then
			debug.setupvalue(counter, 2, 10)
		end
		i = i + 1
	end
until not name

print(counter())
