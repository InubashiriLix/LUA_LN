local term = require("src.terminator")

--- @class text_box_dynamic show a text box, which could maintain the word inside
local text_box_dynamic = {}

--- return a new instance
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
	-- private variables
	local private = {
		text = "",
		text_offset_x = 0,
		text_offset_y = 0,
	}

	-- public variables
	local obj = {
		origin_x = origin_x,
		origin_y = origin_y,
		width = width,
		height = height,
		fg = fg,
		bg = bg,
		border = border,
		rounded = rounded,
		filling = filling,
		num_show_lines = border and height - 2 or height,
		num_max_show_width = border and width - 2 or width,
	}

	-- private methods
	local function compute_text_lines()
		local rtn_table = {}
		for line in private.text:gmatch("[^\r\n]+") do
			table.insert(rtn_table, line)
		end
		return rtn_table
	end

	local function compute_line_max_len()
		local max_len = 0
		for _, line in ipairs(compute_text_lines()) do
			max_len = math.max(max_len, #line)
		end
		return max_len
	end

	-- public methods

	-- update position
	function obj:update_position(new_origin_x, new_origin_y)
		obj.origin_x = new_origin_x
		obj.origin_y = new_origin_y
	end

	--- update texts
	--- @param new_text string
	function obj:update_text(new_text)
		private.text = new_text
	end

	--- update horizontal offset
	--- @param dx number
	function obj:update_offset_x(dx)
		local max_offset = math.max(0, compute_line_max_len() - obj.num_max_show_width)
		private.text_offset_x = math.max(0, math.min(max_offset, private.text_offset_x + dx))
	end

	--- update vertical offset
	--- @param dy number
	function obj:update_offset_y(dy)
		local max_offset = math.max(0, #compute_text_lines() - obj.num_show_lines)
		private.text_offset_y = math.max(0, math.min(max_offset, private.text_offset_y + dy))
	end

	--- rendering the text box
	function obj:render()
		term:box(origin_x, origin_y, width, height, fg, bg, border, rounded, filling)
		local lines = compute_text_lines()
		for i = 1, obj.num_show_lines do
			local line_index = private.text_offset_y + i
			local line = lines[line_index]
			if line then
				term.render_color(fg, bg)
				term:move_to(origin_x + (border and 1 or 0), origin_y + (border and 1 or 0) + i - 1)
				io.write(line:sub(private.text_offset_x + 1, private.text_offset_x + obj.num_max_show_width))
				term.reset_color()
			end
		end
		io:flush()
		-- term:move_to(1, 1)
	end

	return obj
end

return text_box_dynamic
