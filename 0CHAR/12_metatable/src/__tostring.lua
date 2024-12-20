tbl = { 1, 2, 3 }
setmetatable(tbl, {
	__tostring = function(t)
		local rtn_string = ""
		for k, v in pairs(t) do
			rtn_string = rtn_string .. v .. " "
		end
		return rtn_string
	end,
})

print(tbl)
