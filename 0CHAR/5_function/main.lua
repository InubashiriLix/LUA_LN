-- function with access control, parameter and return value
local function max(table)
	local returnValue = table[1]
	for i = 1, #table do
		if table[i] > returnValue then
			returnValue = table[i]
		end
	end
	return returnValue
end

-- main
table = { 1, 2, 3, 4, 5 }
print(max(table))

-- function with multiple return values
local function minmax(table)
	local min = table[1]
	local max = table[1]
	for i = 1, #table do
		if table[i] < min then
			min = table[i]
		end
		if table[i] > max then
			max = table[i]
		end
	end
	return min, max
end

print(minmax(table))

-- mutable count of parameters
local function sum(...)
	local count = 0
	local args = { ... }
	print("length of the parameter: " .. select("#", ...))

	for i = 1, #args do
		if type(args[i]) ~= "number" then
			error("invalid argument")
		end
		count = count + args[i]
	end
	return count
end

print(sum(1, 2, 3, 4, 5))

-- mutable count of parameter with a fixed parameter
local function printSum(prefix, ...)
	local count = 0
	local args = { ... }
	print("the length of the parameters:" .. select("#", ...))
	for index = 1, #args do
		if type(args[index]) ~= "number" then
			error("invalid argument")
		end
		count = count + args[index]
	end
	print(prefix .. " " .. count)
end

printSum("Kill it", 1, 2, 3, 4, 5)
