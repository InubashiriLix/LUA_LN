-- NOTE: WELL, THIS CODING MODE IS NOT RECOMMENDED
--
local module_index_method = {
	tbl1 = {
		table_name = "tbl1",
		table_value = 1,
		table_word = "No way to see",
		printWord = function(self)
			print("Hello form module_index_method" .. self.table_word)
		end,
	},

	values = { 1, 2, 3, 4, 5 },

	tbl1_meta = {
		-- when the
		__name = "tbl1_meta",
		__add = function(self, other)
			return self.table_value + other.table_value
		end,
		-- __index = { 1, 2, 3, 4, 5 },
		__index = function(mytable, key)
			if type(key) == "number" then
				return 1
			else
				return "fuck you!"
			end
		end,
	},
}

setmetatable(module_index_method.tbl1, module_index_method.tbl1_meta)

return module_index_method
