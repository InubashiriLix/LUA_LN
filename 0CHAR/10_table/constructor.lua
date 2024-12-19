-- table, well, it contains the indexes and values
-- and any of index or value can be any  type of data, including table, num, string, function, etc. BUT NOT NIL
--
-- constructor: {}
local tbl1 = {}

tbl1[1] = 1

local function testIndex1()
	print("testIndex1")
	return 0
end
local testIndexValue1 = testIndex1
tbl1[testIndexValue1] = 2

local function testValue1(word)
	print(word)
	return 1
end
local testValueValue1 = testValue1
tbl1[3] = testValueValue1

print(tbl1[3]("this is a test"))

-- use the nil to free the cache or remove the ref
tbl1 = nil
print("test begin")
if tbl1 then
	print(tbl1[3]("this is a test"))
end
print("test end")
