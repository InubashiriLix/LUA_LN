-- variable
--
-- simple test
A = 5
local b = 5

local function test()
	-- in the function, you can access the global variable A
	print(A)
	-- in the function, you can noe access the local variable b
	print(b)
	-- you can create a local variable c in the function, and it can not be accessed outside the function
	local c = 5
	print(c .. " -> c has been created")
	-- reset the value of c
	print("local c has been changed to" .. (function()
		c = 10
		return c
	end)())
	print(c .. " -> c has been created")
end

test()
if c then
	print("c is not nil")
else
	print("c is nil")
end

-- multiple assignment
A, B, C = 10, 10, 10, 10
print(A, B, C)

A, B, C, D = 10, 10, 10
print(A, B, C, D)

-- swaping
A, B = 10, 20
A, B = B, A
print(A, B)

-- index
table = { 1, 2, 3, 4, 5 }
SIX = "six"
table[SIX] = 6
print(table.six)
print(table[SIX])
