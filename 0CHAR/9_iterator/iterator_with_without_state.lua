-- the iterator is an object that allows you to traverse all the elements of a table
-- and all of the iterator object stands for the specific address in the table

-- the generic for loop is a loop that can traverse all the elements of a table
-- it contains three value in the for loop
-- iterator function, control variable, and the state variable
--
for k, v in pairs({ 1, 2, 3, 4, 5 }) do
	print(k, v)
end

-- the second iterator is the itorator WITHOUT STATE
-- like the pairs, it contains the state vaiable (an array),
-- but if we want to create our own iterator, we need to create the stateless iterator
-- example1:
local function stateless1(m, i)
	if i <= m then
		return i + 1
	end
	if i > m then
		return nil
	end
end

for i in stateless1, 6, 0 do
	print(i)
end

-- example2:
for i, n in ipairs({ 1, 2, 3, 4, 5 }) do
	print(i, n)
end

-- example3 with state
local function ipairs_with_state(table) -- the iterator function
	local i = 0
	return function()
		i = i + 1
		if i <= #table then
			return i, table[i]
		else
			return nil
		end
	end
end
for index, value in ipairs_with_state({ 1, 2, 3, 4, 5 }) do
	print(index, value)
end

-- example without state
local function stateless2(hell, current)
	if current <= hell then
		current = current + 1
		return current, current * 2
	end
end

for i, i2 in stateless2, 3, 0 do
	print(i, i2)
end

-- iterator with state using closure
local function closure(final)
	local current = 0
	return function()
		if current < final then
			current = current + 1
			return current, current ^ 2
			-- else return nil
		end
	end
end

for i, square in closure(10) do
	print(i, square)
end
