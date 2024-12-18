-- if
if true then
	print("true")
end

if false then
	print("false")
else
	print("not false")
end

-- for
table = { 1, 2, 3, 4, 5 }
for index, value in pairs(table) do
	print(index, value)
end

-- while
local index = 1
while index <= 5 do
	print(index)
	index = index + 1
end

-- while with continue and break
-- FUCK! continue is not supported in the lua 5.1
index = 1
while index <= 5 do
	if index == 4 then
		print("break")
		break
	end

	if index == 2 then
		print("continue")
		goto continue
	end

	print(index)
	::continue::
	index = index + 1
end

-- repeat until
local count = 5
repeat
	count = count - 1
	print(count)
until count == 0
print("goal")
