local term = require("src.term_components.terminator")
local ayu = require("src.scheme").ayu
local border_sym = require("src.term_components.border_sym")

local config = require("src.config")

--- @class sele_box
local sele_box = {}

--- 创建一个动态文本框实例
--- @param x number The x-coordinate of the top-left corner
--- @param y number The y-coordinate of the top-left corner
--- @param width number The width of the box, including the border
--- @param font_color string? The font color
--- @param sele_color string? the selected bar color
--- @param fg string? The foreground color
--- @param bg string? The background color
--- @param auto_width boolean? Whether to automatically adjust the width
--- @param border boolean? Whether to draw the border
--- @param rounded boolean? Whether to use rounded corners
--- @param filling boolean? Whether to fill the background
function sele_box.new(x, y, width, height, font_color, sele_color, fg, bg, auto_width, border, rounded, filling)
	local obj = {
		x = x and (x > 0 and x or error("bad argument: pos x is nil")) or error("bad argument: pos x > 0"),
		y = y and (y > 0 and y or error("bad argument: pos y is nil")) or error("bad argument: pos y > 0"),
		width = width,
		font_color = (type(font_color) == "string") and font_color or ayu["fg"]["dark"],
		sele_color = (type(sele_color) == "string") and sele_color or ayu["selection"]["dark"],
		fg = (type(fg) == "string") and fg or ayu["fg_idle"]["dark"],
		bg = (type(bg) == "string") and bg or "#000000",
		auto_width = (auto_width ~= nil) and auto_width or false,
		border = (border ~= nil) and border or false,
		rounded = (rounded ~= nil) and rounded or false,
		filling = (filling ~= nil) and filling or true,
		current_sele_index = 1,
	}
	local private = {}

	private.selections = {}

	private.border_sym = {
		tl = obj.rounded and border_sym.tl_round or border_sym.tl_corner,
		tr = obj.rounded and border_sym.tr_round or border_sym.tr_corner,
		bl = obj.rounded and border_sym.bl_round or border_sym.bl_corner,
		br = obj.rounded and border_sym.br_round or border_sym.br_corner,
	}

	--- append the new selection to the private.selections
	--- @param text string the text to append
	--- @param font_c string the font color
	--- @param insert_pos number? the position to insert
	function obj:append_selections(text, font_c, insert_pos)
		if text == nil and #text > 0 then
			error("bad argument in selection_append: the text must be a string longer than 1")
		end

		local temp = { text = text, color = (font_c ~= nil) and font_c or self.font_color }

		if insert_pos ~= nil and insert_pos < #private.selections then
			table.insert(private.selections, insert_pos, temp)
		else
			table.insert(private.selections, temp)
		end

		if self.auto_width then
			self:update_auto_width()
		end
	end

	function obj:clear_selection_set()
		private.selections = nil
	end

	--- update width of the sele_box
	function obj:update_width(new_width)
		self.width = (self.border and new_width > 3) and new_width
			or ((new_width > 0) and new_width or error("bad argument with new width"))
	end

	--- update the auto width state
	--- @param new_state boolean the new state
	function obj:update_auto_width_state(new_state)
		self.auto_width = new_state ~= nil and new_state or false
	end

	--- update the width when the auto width is true
	function obj:update_auto_width()
		if not self.auto_width then
			error("update the auto width when the state is false")
		end

		local temp_width = 0
		for _, item in ipairs(private.selections) do
			temp_width = math.max(#item.text, temp_width)
		end

		if self.border then
			temp_width = 2 + temp_width
		end

		if self.width == 0 then
			error("get 0 for new width when update autowidth state")
		end
		self:update_width(temp_width)
	end

	--- update the rounded state
	--- @param new_round boolean?
	function obj:update_rounded(new_round)
		obj.rounded = new_round == nil and false or new_round
		private.border_sym.tl = obj.rounded and border_sym.tl_round or border_sym.tl_corner
		private.border_sym.tr = obj.rounded and border_sym.tr_round or border_sym.tr_corner
		private.border_sym.bl = obj.rounded and border_sym.bl_round or border_sym.bl_corner
		private.border_sym.br = obj.rounded and border_sym.br_round or border_sym.br_corner
	end

	--- update the symbol of the border
	--- @param position string the position to update
	---     tl ->  top left corner
	---     tr -> top right corner
	---     bl -> bottom left corner
	---     br -> bottom right corner
	--- @param new_border string new border sym
	function obj:update_border_sym(position, new_border)
		if #new_border == 0 then
			error("invalid new border sym")
		end
		-- switch
		private.border_sym[position] = new_border
	end

	--- render the graph
	function obj:render()
		if not private.selections then
			return
		end

		local upper_border_temp_width = config.settings.sele_box.show_index and self.width + 2 or self.width

		if self.border then
			term:render_color(self.fg, self.bg)
			self.x, self.y = self.x, self.y + 1
			term:move_to(self.x, self.y)
			io.write(private.border_sym.tl .. (border_sym.h):rep(upper_border_temp_width) .. private.border_sym.tr)
		end

		local temp_v_border = self.border and border_sym.v or ""

		for index, current_item in ipairs(private.selections) do
			-- move cursor
			self.x, self.y = self.x, self.y + 1
			term:move_to(self.x, self.y)

			-- prepare the text to display
			local current_item_text
			if self.auto_width then
				current_item_text = current_item.text
			else
				current_item_text = self.border and current_item.text:sub(1, self.width - 2) or current_item.text
			end

			-- prepare the color
			if index == self.current_sele_index then
				term:render_color(self.sele_color, self.bg)
			else
				term:render_color(self.fg, self.bg)
			end

			if config.settings.sele_box.show_index then
				io.write(
					temp_v_border
						.. tostring(index)
						.. " "
						.. current_item_text
						.. (" "):rep(self.width - #current_item_text)
						.. temp_v_border
				)
			else
				io.write(temp_v_border .. current_item_text .. temp_v_border)
			end
		end

		if self.border then
			self.x, self.y = self.x, self.y + 1
			term:render_color(self.fg, self.bg)
			term:move_to(self.x, self.y)
			io.write(private.border_sym.bl .. border_sym.h:rep(upper_border_temp_width) .. private.border_sym.br)
		end
	end

	setmetatable(obj, sele_box)

	return obj
end

return sele_box
