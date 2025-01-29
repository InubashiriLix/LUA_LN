local windows = {}
local term = require("src.terminator")
local scheme = require("src.scheme")

function windows:new()
	local obj = {
		width = 3,
		lendth = 3,
		origin_x = 1,
		origin_y = 1,
		fg = 1,
		bg = 1,
		border = false,
	}
	-- self.box
	obj.__index = self
	return setmetatable(obj, self)
end

-- function windows:

return module
