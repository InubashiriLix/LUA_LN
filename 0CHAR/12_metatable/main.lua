local metatable_example = require("src.metatable")
local index_test = require("src.__index")
local newindex_test = require("src.__newindex")

local meta = getmetatable(metatable_example.tbl)
print(meta.name)

local index_tbl = index_test.tbl1
print(index_tbl[1] + index_tbl[2])

local newindex_tbl = newindex_test.tbl1
newindex_tbl["test"] = "test"
newindex_tbl[1] = "shit"
newindex_tbl.shit = "kill you all"
print(newindex_tbl.name)
print(newindex_tbl.test)
print(newindex_tbl[1])
print(newindex_tbl.shit)
