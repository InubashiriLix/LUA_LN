local ayu = require("src.scheme").ayu
local border_sym = require("src.term_components.border_sym")
local term = require("src.term_components.terminator")

local config = require("src.config")

--- @class sele_box
local sele_box = {}

--- 创建一个动态文本框实例
--- @param x number The x-coordinate of the top-left corner
--- @param y number The y-coordinate of the top-left corner
--- @param width number The width of the box, including the border
--- @param height number? The height of the box, if you provide this, then the height will be fixed
--- @param font_color string? The font color
--- @param sele_color string? the selected bar color
--- @param sele_bg_color string? the selected bar background color
--- @param fg string? The foreground color
--- @param bg string? The background color
--- @param auto_width boolean? Whether to automatically adjust the width
--- @param border boolean? Whether to draw the border
--- @param rounded boolean? Whether to use rounded corners
--- @param filling boolean? Whether to fill the background
function sele_box.new(
	x,
	y,
	width,
	height,
	font_color,
	sele_color,
	sele_bg_color,
	fg,
	bg,
	auto_width,
	border,
	rounded,
	filling
)
	local obj = {
		x = x and (x >= 0 and x or error("bad argument: pos x is nil")) or error("bad argument: pos x > 0"),
		y = y and (y >= 0 and y or error("bad argument: pos y is nil")) or error("bad argument: pos y > 0"),
		width = width,
		height = (height ~= nil and height > 0) and height or 0, -- NOTE: the 0 is assigned as spectial value meaning fixed height off
		font_color = (type(font_color) == "string") and font_color or ayu["fg"]["dark"],
		sele_color = (type(sele_color) == "string") and sele_color or ayu["selection"]["dark"],
		fg = (type(fg) == "string") and fg or ayu["fg_idle"]["dark"],
		bg = (type(bg) == "string") and bg or "#000000",
		auto_width = (auto_width ~= nil) and auto_width or false,
		border = (border ~= nil) and border or false,
		rounded = (rounded ~= nil) and rounded or false,
		filling = (filling ~= nil) and filling or true,
		current_sele_index = 1,
		header = nil,
	}

	-- use the selected selection background color if it is given or use the complementary color or sele color
	obj.sele_bg_color = (type(sele_bg_color) ~= "string") and term:get_complementary_color(obj.sele_color)
		or sele_bg_color

	local private = {}

	private.selections = {}

	private.border_sym = {
		tl = obj.rounded and border_sym.tl_round or border_sym.tl_corner,
		tr = obj.rounded and border_sym.tr_round or border_sym.tr_corner,
		bl = obj.rounded and border_sym.bl_round or border_sym.bl_corner,
		br = obj.rounded and border_sym.br_round or border_sym.br_corner,
	}

	function obj:_get_sele_show_lines()
		if self.height ~= 0 then -- if the height is given, that is fixed
			if self.border then
				return self.height - 2
			else
				return self.height
			end
		else -- if the height is not given, that is as long as you want
			return #private.selections
		end
	end

	-- NOTE: will be use only when the height is give a valid value, that is the box is not a fix height
	private.upper_border_idx = 1
	if height ~= 0 then
		private.bottom_border_idx = math.min(obj:_get_sele_show_lines(), #private.selections)
	end

	--- append the new selection to the private.selections
	--- @param text string the text to append
	--- @param font_c string? the font color
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
		if height ~= 0 then
			local temp_height = (obj.border == false) and height or height - 2
			private.bottom_border_idx = math.min(temp_height, #private.selections)
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

	--- update the header of the sele_box
	--- @param new_header string the new headedr
	--- if you set the new header as nil, then the header will not displayed
	--- no default decorations around, add them if you want
	function obj:update_header(new_header)
		self.header = new_header
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

		local temp_width = self.border and self.width - 2 or self.width
		local temp_x = self.x
		local temp_y = self.y

		if self.border then
			term:render_color(self.fg, self.bg)
			temp_x, temp_y = temp_x, temp_y + 1
			term:move_to(temp_x, temp_y)
			local temp_head_border = ""
			if self.header ~= nil then
				temp_head_border = (#self.header >= temp_width - 2)
						and private.border_sym.tl .. border_sym.h:rep(1) .. self.header:sub(1, temp_width - 2) .. border_sym.ellipsis .. private.border_sym.tr
					or private.border_sym.tl
						.. border_sym.h:rep(1)
						.. self.header
						.. border_sym.h:rep(temp_width - 1 - #self.header)
						.. private.border_sym.tr
			else
				temp_head_border = private.border_sym.tl .. border_sym.h:rep(temp_width) .. private.border_sym.tr
			end
			io.write(temp_head_border)
		end

		local temp_v_border = self.border and border_sym.v or ""

		--- check the index is between the upper and bottom index
		--- <= curr_index <=
		--- @param index_upper number the upper index
		--- @param curr_index number the current index
		--- @param index_bottom number the bottom index
		local function between(index_upper, curr_index, index_bottom)
			return index_upper <= curr_index and curr_index <= index_bottom
		end

		local temp_lower_border = math.max(private.bottom_border_idx, self:_get_sele_show_lines())
		if self.height > 0 then -- the height is fixed
			for index = private.upper_border_idx, temp_lower_border do
				if between(private.upper_border_idx, index, private.bottom_border_idx) then -- if the
					-- move cursor
					temp_x, temp_y = temp_x, temp_y + 1
					term:move_to(temp_x, temp_y)
					-- prepare the text to display
					local current_item_text
					if self.auto_width then
						current_item_text = private.selections[index].text
					else
						current_item_text = self.border and private.selections[index].text:sub(1, self.width - 2)
							or private.selections[index].text
					end
					-- prepare the color
					if index == self.current_sele_index then
						term:render_color(self.sele_color, self.sele_bg_color)
					else
						term:render_color(private.selections[index].color, self.bg)
					end
					local temp_show_item = config.settings.sele_box.show_index
							and tostring(index) .. " " .. current_item_text
						or current_item_text
					io.write(
						temp_v_border .. temp_show_item .. (" "):rep(temp_width - #temp_show_item) .. temp_v_border
					)
				else
					-- if the index is not in the range
					-- move cursor
					temp_x, temp_y = temp_x, temp_y + 1
					term:move_to(temp_x, temp_y)

					io.write(temp_v_border .. (" "):rep(temp_width) .. temp_v_border)
				end
			end
		elseif self.height == 0 then -- the heigh is not fixed
			for index, current_item in ipairs(private.selections) do
				-- move cursor
				temp_x, temp_y = temp_x, temp_y
				term:move_to(temp_x, temp_y)

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
							.. (" "):rep(temp_width - #current_item_text)
							.. temp_v_border
					)
				else
					io.write(current_item_text .. (" "):rep(self.width - #current_item_text) .. temp_v_border)
				end
			end
		else
			error("the height fixed mode error")
		end

		if self.border then
			temp_x, temp_y = temp_x, temp_y + 1
			term:render_color(self.fg, self.bg)
			term:move_to(temp_x, temp_y)
			io.write(private.border_sym.bl .. border_sym.h:rep(temp_width) .. private.border_sym.br)
		end
	end

	--- scroll a half page
	--- @param is_down
	function obj:scroll_half(is_down)
		local step = is_down --
	end

	--- scroll the item
	--- @param step number the step to update
	---     negetive for scrolling up
	---     positive for scrolling down
	function obj:scroll(step)
		local temp_sele_len = #private.selections
		-- index border part
		if (self.current_sele_index + step <= temp_sele_len) and (self.current_sele_index + step > 0) then
			self.current_sele_index = self.current_sele_index + step
		elseif self.current_sele_index + step > temp_sele_len then
			-- just set the curr_index as 0
			self.current_sele_index = 1
			private.upper_border_idx = 1
			private.bottom_border_idx = math.min(temp_sele_len, self:_get_sele_show_lines())
		elseif self.current_sele_index + step < 1 then
			-- just set the curr_index = temp_sele_len
			self.current_sele_index = temp_sele_len
			private.upper_border_idx = math.max(1, temp_sele_len - self:_get_sele_show_lines() + 1)
			private.bottom_border_idx = temp_sele_len
		end
		-- gui render set
		-- dont worry about the current_index range, it has been dealed in index border part above
		if self.height > 0 then -- if the fixed height is on
			if self.current_sele_index >= private.bottom_border_idx then
				-- update the uppper border idx
				local temp_bottom_idx = math.min(self.current_sele_index + 4, temp_sele_len)
				local temp_diff = temp_bottom_idx - private.bottom_border_idx
				private.bottom_border_idx = temp_bottom_idx

				-- update the bottom border idx
				private.upper_border_idx = private.upper_border_idx + temp_diff
				-- re render is needed
			elseif self.current_sele_index < private.upper_border_idx then
				-- update  the upper_border_idx
				local temp_upper_idx = math.max(1, private.upper_border_idx - 4)
				local temp_diff = private.upper_border_idx - temp_upper_idx -- the diff is hoped to be positive
				private.upper_border_idx = temp_upper_idx

				-- update the bottom border idx
				private.bottom_border_idx = private.bottom_border_idx - temp_diff
			end
		end
	end

	obj.private = private

	setmetatable(obj, sele_box)

	return obj
end

return sele_box
