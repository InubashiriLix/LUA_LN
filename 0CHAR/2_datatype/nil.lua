-- nil can stand for the absence of a value
print(type(a))

-- nil can also be used to delete a value from a tables
table1 = { key1 = "one", key2 = "two", key3 = "three" }
for index, value in pairs(table1) do
	print(index, " == ", value)
end

table1.key1 = nil
for k, v in pairs(table1) do
	print(k, v)
end

-- telling wehter a variable is nil or not
if a == nil then
	print("a is nil")
elseif a == "nil" then
	print('a is "nil"')
end

if type(a) == "nil" then
	print('type(a) is "nil"')
end
