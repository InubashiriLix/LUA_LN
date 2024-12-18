-- creating a new table
local a = {}

-- adding some key or value to the table
a[1] = "1"
print(a[1])
a[1] = a[1] + 1
print(a[1])

index = "meaning"
a[index] = "I hope this will hurt"
print(a[index])

-- creating a table with some values
local lastword = { "I", "hope", "this", "will", "hurt" }
-- the index is ranging from 1 to 5
lastword["testIndex"] = "testIndex1"
for k, v in pairs(lastword) do
	print(k .. " == " .. v)
end
