local module_newindex_test = {}

local tbl1 = {}
tbl1.name = "module_newindex_test.tbl1"
tbl1.value = 0
tbl1.printName = function()
	print(tbl1.name)
end
tbl1.printValue = function()
	print(tbl1.value)
end

local tbl1_meta = {}
tbl1_meta.__name = "module_newindex_test.tbl1_meta"
tbl1_meta.__inedx = function(key)
	if type(key) == "number" then
		return 123
	else
		return "want int"
	end
end
tbl1_meta.__newindex = function(mytable, key, value)
	rawset(mytable, key, '"' .. value .. '"')
end

setmetatable(tbl1, tbl1_meta)
module_newindex_test.tbl1 = tbl1

return module_newindex_test
