local term = require("src.term_components.terminator")
local text_box_static = require("src.term_components.text_box_static")

--- @class text_box_dynamic : text_box_static
local text_box_dynamic = setmetatable({}, { __index = text_box_static })

--- 创建一个动态文本框实例
--- @param origin_x number The x-coordinate of the top-left corner
--- @param origin_y number The y-coordinate of the top-left corner
--- @param width number The width of the box, including the border
--- @param height number The height of the box, including the border
--- @param fg string The foreground color
--- @param bg string The background color
--- @param border boolean? Whether to draw the border
--- @param rounded boolean? Whether to use rounded corners
--- @param filling boolean? Whether to fill the background
function text_box_dynamic:new(origin_x, origin_y, width, height, fg, bg, border, rounded, filling)
	-- use the static text box as the base class
	local obj = text_box_static:new("", origin_x, origin_y, fg, bg, width, height, border, rounded, filling)

	-- private properties
	local private = {
		text = "", -- dynamic text content
		text_offset_x = 0, -- horizontal offset
		text_offset_y = 0, -- vertical offset
	}

	-- private method: compute the number of text lines
	local function compute_text_lines()
		local rtn_table = {}
		for line in private.text:gmatch("[^\r\n]+") do
			table.insert(rtn_table, line)
		end
		return rtn_table
	end

	-- compute the maximum length of the text lines
	local function compute_line_max_len()
		local max_len = 0
		for _, line in ipairs(compute_text_lines()) do
			max_len = math.max(max_len, #line)
		end
		return max_len
	end

	-- APIs
	--- update the text content
	--- @param new_text string
	function obj:update_text(new_text)
		if new_text then
			private.text = new_text
		end
		-- obj:update_size(obj.width, obj.height) -- update size
	end

	--- update horizontal offset
	--- @param dx number
	function obj:update_offset_x(dx)
		local max_offset = math.max(0, compute_line_max_len() - obj.num_max_show_width)
		private.text_offset_x = math.max(0, math.min(max_offset, private.text_offset_x + dx))
	end

	--- update the vertical offset
	--- @param dy number
	function obj:update_offset_y(dy)
		local max_offset = math.max(0, #compute_text_lines() - (self.border and (self.height - 2) or self.height))
		private.text_offset_y = math.max(0, math.min(max_offset, private.text_offset_y + dy))
	end

	--- rendering the dynamic text box
	function obj:render()
		local lines = compute_text_lines()
		local text_abs_x = obj.origin_x + (obj.border and 1 or 0)
		local text_abs_y = obj.origin_y + (obj.border and 1 or 0)
		local text_max_width = self.border and self.width - 2 or self.width
		local num_lines = obj.border and obj.height - 2 or obj.height

		-- set the color
		term:render_color(obj.fg, obj.bg)

		-- render the border
		if obj.border then
			term:move_to(obj.origin_x, obj.origin_y)
			local top_border = obj.border_syms.tl_corner
				.. string.rep(obj.border_syms.h, obj.width - 2)
				.. obj.border_syms.tr_corner
			io.write(top_border)
		end

		-- render the content
		for i = 1, num_lines do
			local line_index = private.text_offset_y + i
			local line = lines[line_index] or ""

			term:move_to(obj.origin_x, obj.origin_y + i)
			if obj.border then
				io.write(obj.border_syms.v) -- left side
			end

			-- render the text content
			io.write(line:sub(private.text_offset_x + 1, private.text_offset_x + text_max_width))

			-- render the padding
			io.write(
				string.rep(
					" ",
					text_max_width - #line:sub(private.text_offset_x + 1, private.text_offset_x + text_max_width)
				)
			)

			if obj.border then
				io.write(obj.border_syms.v) -- right side bar
			end
		end

		-- render the bottom border
		if obj.border then
			term:move_to(obj.origin_x, obj.origin_y + obj.height - 1)
			local bottom_border = self.border_syms.bl_corner
				.. string.rep(self.border_syms.h, obj.width - 2)
				.. self.border_syms.br_corner
			io.write(bottom_border)
		end

		term:reset_color()

		io.flush()
	end

	return setmetatable(obj, { __index = self })
end

return text_box_dynamic
