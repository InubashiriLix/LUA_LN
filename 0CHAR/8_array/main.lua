-- use the index to access the value of the array
local myArray = { 1, 2, 3, 4, 5 }
print(myArray[1])

-- use the # to get the length of the array
print(#myArray)

-- use the for loop to access the value of the array
for i = 1, #myArray do
	print(myArray[i])
end

-- visiting a value that does not exist will return nil
print(myArray[7])

-- change the value of the array
-- lambda function there
print((function()
	print(myArray[1])
	myArray[1] = 10
	print(myArray[1])
end)())

-- remove the value of the array usint the table.remove(tablename, index)
table.remove(myArray, 1)
print(myArray[1]) -- it should be 2 now

-- multi-dimensional array
-- creating
local array = {}
for i = 1, 3 do
	array[i] = {}
	for j = 1, 3 do
		array[i][j] = i * j
	end
end
print(array)

-- creating
local array1 = { {}, {}, {} }
for i = 1, #array1 do
	for j = 1, 3 do
		array1[i][j] = i * j
	end
end
print(array1)

-- can table contain the function?
local fuc = function()
	print("Hello")
end
local array2 = { fuc }
print(array2[1]()) -- it should print Hello
