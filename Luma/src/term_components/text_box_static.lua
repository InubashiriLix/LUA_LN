local term = require("src.term_components.terminator")
local text_box_static = {}

--- @ class text_box_static

--- a static text box that can not interact with
--- @param text_ string The text to display
--- @param origin_x_ number? The x-coordinate of the top-left corner
--- @param origin_y_ number? The y-coordinate of the top-left corner
--- @param width_ number? The width of the box, including the border
--- @param height_ number? The height of the box, including the border
--- @param fg_ string? The foreground color
--- @param bg_ string? The background color
--- @param border_ boolean? Whether to draw the border
--- @param rounded_ boolean? Whether to use rounded corners
--- @param filling_ boolean? Whether to fill the background
function text_box_static:new(text_, origin_x_, origin_y_, fg_, bg_, width_, height_, border_, rounded_, filling_)
	local obj = {
		-- to cope with the origin_x is nil or 0 or minus
		text = text_ or "",
		origin_x = not origin_x_ and 1 or (origin_x_ > 0 and origin_x_ or 1),
		origin_y = not origin_y_ and 1 or (origin_y_ > 0 and origin_y_ or 1),
		width = width_,
		height = height_,
		fg = fg_ or "#FFFFFF",
		bg = bg_ or "#000000",
		border = border_ or false,
		rounded = rounded_ or false,
		filling = filling_ == nil and true or filling_,
	}

	local private = {
		text_lines = {},
	}

	private.num_text_showable_lines = function()
		if obj.border then
			return obj.height - 2
		elseif not obj.border then
			return obj.height
		end
	end

	local function get_lines_tbl()
		local rtn_lines = {}
		for line in obj.text:gmatch("[^\r\n]+") do
			table.insert(rtn_lines, line)
		end
		return rtn_lines
	end

	private.text_lines_max_len = function()
		if #private.text_lines == 0 then
			private.text_lines = get_lines_tbl()
		end
		local temp = 0
		for _, line in ipairs(private.text_lines) do
			if temp < #line then
				temp = #line
			end
		end
		return temp
	end

	private.text_max_showable_len = function()
		return obj.width - (obj.border and 2 or 0)
	end

	--- update the cotent
	--- @param new_text string?
	function obj:update_text(new_text)
		self.text = new_text and new_text or ""
		-- do not forget to update lines table
		private.text_lines = get_lines_tbl()
	end

	--- initialize the content inside
	obj:update_text(obj.text)

	---update the position of the box
	---@param new_x number
	---@param new_y number
	function obj:update_pos(new_x, new_y)
		self.origin_x = new_x and new_x or self.origin_x
		self.origin_y = new_y and new_y or self.origin_y
	end

	function obj:update_size(new_width, new_len)
		if not new_width then
			local temp_max_len = private.text_lines_max_len()
			self.width = self.border and (2 + temp_max_len) or temp_max_len
		elseif new_width and ((new_width >= 3) or (new_width >= 1 and not self.border)) then
			self.width = new_width
		else
			error("invalid width argument")
		end

		if not new_len then
			self.height = self.border and (#private.text_lines + 2) or #private.text_lines
		elseif new_len and ((new_len >= 3) or (new_len >= 1 and not self.border)) then
			self.height = new_len
		else
			error("invalid len argument")
		end
	end

	-- initialize the width and height
	obj:update_size(obj.width, obj.height)

	--- update the color
	--- @param new_fg string?
	--- @param new_bg string?
	function obj:update_color(new_fg, new_bg)
		self.fg = new_fg and new_fg or self.fg
		self.bg = new_bg and new_bg or self.bg
	end

	--- update the border state
	function obj:update_border(new_border)
		if new_border == nil then
			error("update border argument is nil")
		end
		self.border = new_border
	end

	--- render the gragh
	--- render the text box
	function obj:render()
		if self.border then
			term:render_color(self.fg, self.bg)
			term:move_to(self.origin_x, self.origin_y)
			local top_border = (self.rounded and "╭" or "┌")
				.. string.rep("─", self.width - 2)
				.. (self.rounded and "╮" or "┐")
			io.write(top_border)
		end

		local text_max_width = private.text_max_showable_len()

		for i = 1, self.height - (self.border and 2 or 0) do
			local line = private.text_lines[i] or ""
			local padded_line = line:sub(1, text_max_width)

			term:move_to(self.origin_x, self.origin_y + i)
			if self.border then
				term:render_color(self.fg, self.bg)
				io.write("│")
			end

			term:render_color(self.fg, self.bg)
			io.write(padded_line .. string.rep(" ", text_max_width - #padded_line))
			term:reset_color()

			if self.border then
				term:render_color(self.fg, self.bg)
				io.write("│")
			end
		end

		if self.border then
			term:move_to(self.origin_x, self.origin_y + self.height - 1)
			term:render_color(self.fg, self.bg)
			local bottom_border = (self.rounded and "╰" or "└")
				.. string.rep("─", self.width - 2)
				.. (self.rounded and "╯" or "┘")
			io.write(bottom_border)
		end

		term:reset_color()
		io.flush()
	end

	function obj:dispear()
		term:filling_rectangle(self.origin_x, self.origin_y, self.width, self.height, self.bg)
	end

	function obj:move_to(x, y)
		self:update_pos(x, y)
		self:dispear()
		self:render()
	end

	return setmetatable(obj, self)
end

return text_box_static
