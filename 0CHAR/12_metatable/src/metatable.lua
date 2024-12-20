METATABLE_EXAMPLE = {}

METATABLE_EXAMPLE.tbl = {}
METATABLE_EXAMPLE.tbl.word = "Hello and stirb. "
METATABLE_EXAMPLE.tbl.printWord = function()
	print(METATABLE_EXAMPLE.tbl.word)
end

local tbl_meta = {}
tbl_meta.name = "metatable of tbl in the METATABLE_EXAMPLE"
tbl_meta.__add = function(tbl1, tbl2)
	return tbl1.word .. tbl2.word
end
setmetatable(METATABLE_EXAMPLE.tbl, tbl_meta)

return METATABLE_EXAMPLE
