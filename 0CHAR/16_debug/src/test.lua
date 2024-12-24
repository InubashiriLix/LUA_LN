local function add(a, b)
	assert(type(a) == "number", "a is not a number")
	assert(type(b) == "number", "b is not a number")
	return a + b
end

local function printTraceback(err)
	print("most recent error traceback:")
	print(err)
end

local function test()
	if pcall(add, 1) then
		print("adding 1 and nil done")
	else
		print("error when adding 1 and nil")
	end

	local result1 = xpcall(add, printTraceback, 1, 2)
	print("result1: " .. tostring(result1))
	local result2 = xpcall(add, printTraceback, "add", 2)
	print("result2: " .. tostring(result2))
end

local module_test = {}
module_test.add = add
module_test.printTraceback = printTraceback
module_test.test = test

return module_test
