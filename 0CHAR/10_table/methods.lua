local complex_table = {
	[true] = "boolean true",
	[false] = "boolean false",
	["string"] = 42,
	[42] = "number as key",
	[function(x)
		return x
	end] = "function as key",
	[{ 1, 2, 3 }] = "table as key",
	["table as value"] = { a = 1, b = 2 },
	[3.14] = "float number as key",
	-- [nil] = "nil as key", -- nil keys are ignored in tables
}

local simple_table = {
	["this is a test"] = "no one is here ",
	["index2"] = "no solution there ",
	["index3"] = "no silver bullet ",
}

-- concatnating
print("concatnating")

local simple_array = {
	"no one here",
	"no solution there",
	"no silver bullet",
}

print(table.concat(simple_array))
print(table.concat(simple_array, ", "))
print(table.concat(simple_array, ", ", 2, 3))

-- removing
print("removing")
table.remove(simple_array, 1)
print(table.concat(simple_array, ", "))

-- inserting
print("inserting")
table.insert(simple_array, 1, "stirb fur mich")
print(table.concat(simple_array, ", "))

-- sorting
print("sorting")
local numbers = { 4, 5, 3, 2, 1 }
table.sort(numbers)
for k, v in ipairs(numbers) do
	print(k, v)
end

local words = { "no more running", "it does not exist", "come here" }
table.sort(words)
for k, v in ipairs(words) do
	print(k, v)
end
