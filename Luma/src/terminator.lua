local term_module = {}

--- ANCII escape code
local ESC = "\27["

--- the size info, we should not call this function frequently
term_module.size = { cols = 0, rows = 0, updated = false }

--- the cursor info
term_module.cursor = { x = 0, y = 0 }

--- Error handler
local function error_handler(err)
	print("ERROR:", err)
end

--- clear the terminal screen
function term_module.clear()
	io.write(ESC .. "2J") -- 清屏
	io.write(ESC .. "H") -- 将光标移动到左上角
	io.flush()
end

--- get the size of the terminal
--- return 1: cols, 2: rows
--- @return number, number
function term_module.get_size()
	local handle = io.popen("stty size", "r")
	if handle == nil then
		error("term_module: get_size() handle is nil failed")
	end
	local result = handle:read("*a")
	handle:close()
	local rows, cols = string.match(result, "(%d+)%s+(%d+)")
	assert(rows and cols, "term_module: get_size() failed to get the size")
	term_module.size.updated = true
	term_module.size.cols = tonumber(cols)
	term_module.size.rows = tonumber(rows)
	return term_module.size.cols, term_module.size.rows
end

--- update the terminal size
function term_module:update_term_size()
	self.get_size()
end

--- move the cursor to the position (x, y)
--- and update the cursor.x, y
function term_module:move_to(x, y)
	if not self.size.updated then
		self:update_term_size()
	end
	if x > self.size.cols or y > self.size.rows then
		error("term_module:move_to() x or y is out of range")
	end
	-- if x > self.size.cols then
	-- 	error("move to error, with x: " .. x .. " and cols: " .. self.size.cols)
	-- end
	-- if y > self.size.rows then
	-- 	error("move to error, with y: " .. y .. " and rows: " .. self.size.rows)
	-- end
	io.write(ESC .. y .. ";" .. x .. "H")
	io.flush()
	self.cursor.x = x
	self.cursor.y = y
end

--- move the cursor vertically
--- @param n number the number of lines to move, positive for down, negative for up
function term_module:move_vertically(n)
	local new_y = math.max(1, math.min(self.size.rows, self.cursor.y + n))
end

--- move  the cursor horizontally
--- @param n number the number of cols to move, positive for right, negative for left
function term_module:move_horizontally(n)
	local new_x = math.max(1, math.min(self.size.cols, self.cursor.x + n))
end

--===============  colors ====================

--- Convert HEX color to RGB
---@param hex string
---@return number, number, number
local function hex_to_rgb(hex)
	local r = tonumber(hex:sub(2, 3), 16)
	local g = tonumber(hex:sub(4, 5), 16)
	local b = tonumber(hex:sub(6, 7), 16)
	return r, g, b
end

--- use the RGB values to render the color
--- @param fg string foreground color
--- @param bg string background color
function term_module:render_color(fg, bg)
	if fg then
		local r, g, b = hex_to_rgb(fg)
		io.write(string.format("\27[38;2;%d;%d;%dm", r, g, b))
	end
	if bg then
		local r, g, b = hex_to_rgb(bg)
		io.write(string.format("\27[48;2;%d;%d;%dm", r, g, b))
	end
end

--- reset the color to default
function term_module:reset_color()
	io.write(ESC .. "0m")
end

--- print something at x, y
function term_module:print_at(x, y, text, fg, bg)
	term_module:move_to(x, y)
	term_module:render_color(fg, bg)
	io.write(text)
	term_module:reset_color()
end

--- ================== the drawing part ======================
--- NOTE: the bellowing functions are not instance, they need FLUSH to the terminal

--- Draw a horizontal line using ASCII box-drawing characters
--- @param x number Start column
--- @param y number Start row
--- @param len number Length of the line
--- @param fg string Foreground HEX color
--- @param bg string Background HEX color
function term_module:horizontal_line(x, y, len, fg, bg)
	if len <= 0 then
		error("term_module: horizontal_line() length must be greater than 0")
	end
	if x + len - 1 > self.size.cols then
		error("term_module: horizontal_line() x + len is out of range")
	end
	self:move_to(x, y)
	self:render_color(fg, bg)
	io.write(string.rep("─", len)) -- 使用 ASCII 符号 `─`
	self:reset_color()
end

--- Draw a vertical line using ASCII box-drawing characters
--- @param x number Start column
--- @param y number Start row
--- @param len number Length of the line
--- @param fg string Foreground HEX color
--- @param bg string Background HEX color
function term_module:vertical_line(x, y, len, fg, bg)
	if len <= 0 then
		error("term_module: vertical_line() length must be greater than 0")
	end
	if y + len - 1 > self.size.rows then
		error("term_module: vertical_line() y + len is out of range")
	end
	self:render_color(fg, bg)
	for i = 0, len - 1 do
		self:move_to(x, y + i)
		io.write("│") -- 使用 ASCII 符号 `│`
	end
	self:reset_color()
end

local tl_corner = "┌"
local tr_corner = "┐"
local bl_corner = "└"
local br_corner = "┘"

local tl_round = "╭"
local tr_round = "╮"
local bl_round = "╰"
local br_round = "╯"

--- Draw a box with square or rounded corners
--- @param origin_x number The x-coordinate of the top-left corner
--- @param origin_y number The y-coordinate of the top-left corner
--- @param width number The width of the box, including the border
--- @param height number The height of the box, including the border
--- @param fg string The foreground color
--- @param bg string The background color
--- @param rounded boolean? Whether to use rounded corners
function term_module:border(origin_x, origin_y, width, height, fg, bg, rounded)
	if width < 2 or height < 2 then
		error("term_module:box() width and height must be at least 2")
	end

	local tl, tr, bl, br = tl_corner, tr_corner, bl_corner, br_corner
	if rounded then
		tl, tr, bl, br = tl_round, tr_round, bl_round, br_round
	end

	-- Render colors
	if fg or bg then
		self:render_color(fg, bg)
	end

	-- Print top border
	self:move_to(origin_x, origin_y)
	io.write(tl .. string.rep("─", width - 2) .. tr)

	-- Print sides
	for i = 1, height - 2 do
		self:move_to(origin_x, origin_y + i)
		io.write("│")
		self:move_to(origin_x + width - 1, origin_y + i)
		io.write("│")
	end

	-- Print bottom border
	self:move_to(origin_x, origin_y + height - 1)
	io.write(bl .. string.rep("─", width - 2) .. br)

	-- Reset colors
	if fg or bg then
		self:reset_color()
	end
end

--- Draw a rectangle
--- @param origin_x number The x-coordinate of the top-left corner
--- @param origin_y number The y-coordinate of the top-left corner
--- @param width number The width of the rectangle
--- @param height number The height of the rectangle
--- @param color_hex string The HEX color
function term_module:filling_rectangle(origin_x, origin_y, width, height, color_hex)
	self:render_color(color_hex, color_hex)
	for i = 0, height do
		self:move_to(origin_x, origin_y + i)
		io.write((" "):rep(width))
	end
	self:reset_color()
	io.flush()
end

--- @class term_module.compotents
term_module.components = {}

--- @class term_module.components.box
term_module.components.box = {}

--- @function term_module.components.box:new
--- Draw a box with square or rounded corners
--- @param origin_x number The x-coordinate of the top-left corner
--- @param origin_y number The y-coordinate of the top-left corner
--- @param width number The width of the box, including the border
--- @param height number The height of the box, including the border
--- @param fg string The foreground color
--- @param bg string The background color
--- @param border boolean? Whether to draw the border
--- @param rounded boolean? Whether to use rounded corners
--- @param filling boolean? Whether to fill the background
function term_module.components.box:new(origin_x, origin_y, width, height, fg, bg, border, rounded, filling)
	local obj = {
		origin_x = origin_x,
		origin_y = origin_y,
		width = width,
		height = height,
		fg = fg or "#FFFFFF",
		bg = bg or "#000000",
		border = border == nil and false or border,
		rounded = rounded == nil and false or rounded,
		filling = filling == nil and true or filling,
	}

	obj.__index = term_module

	--- update the position of the box
	--- @param x number the x-coordinate of the top-left corner
	--- @param y number the y-coordinate of the top-left corner
	function obj:update_pos(x, y)
		self.origin_x = x == nil and self.origin_x or (x > 0 and x or self.origin_x)
		self.origin_y = y == nil and self.origin_y or (y > 0 and y or self.origin_y)
	end

	setmetatable(obj, term_module)

	--- render the graph
	--- using the obj's properties
	function obj:render()
		-- compute all the graph first, then render (flush)
		term_module:render_color(self.fg, self.bg)
		term_module:move_to(self.origin_x, self.origin_y)
		if self.border then -- draw border
			if self.rounded then
				io.write("╭" .. string.rep("─", self.width - 2) .. "╮")
			else
				io.write("┌" .. string.rep("─", self.width - 2) .. "┐")
			end
		else -- no border
			io.write(string.rep(" ", self.width))
		end

		for i = 1, height - 1 do
			term_module:move_to(self.origin_x, self.origin_y + i)
			io.write(self.border and ("│" .. (" "):rep(self.width - 2) .. "│") or ((" "):rep(self.width)))
		end

		term_module:move_to(self.origin_x, self.origin_y + self.height)
		if self.border then -- draw border
			if self.rounded then
				io.write(bl_round .. string.rep("─", self.width - 2) .. br_round)
			else
				io.write(bl_corner .. string.rep("─", self.width - 2) .. br_corner)
			end
		else -- no border
			io.write(string.rep(" ", self.width))
		end

		term_module:reset_color()

		io.flush()
	end

	function obj:dispear()
		term_module:filling_rectangle(self.origin_x, self.origin_y, self.width, self.height, self.bg)
	end

	--- move the box to the new position
	--- @param x number the x-coordinate of the top-left corner
	--- @param y number the y-coordinate of the top-left corner
	function obj:move_to(x, y)
		self:dispear()
		self:update_pos(x, y)
		self:render()
	end

	function obj:stirb()
		obj:dispear()
		-- obj = nil
	end

	return obj
end

--- @class term_module.components.progress_bar
term_module.components.progress_bar = {}

--- Draw a progress bar
--- @param origin_x number The x-coordinate of the top-left corner
--- @param origin_y number The y-coordinate of the top-left corner
--- @param width number The width of the box, including the border
--- @param height number The height of the box, including the border
--- @param fg string The foreground color
--- @param bg string The background color
function term_module.components.progress_bar:new(origin_x, origin_y, width, height, fg, bg)
	local obj = {
		origin_x = origin_x,
		origin_y = origin_y,
		width = width or 20,
		height = height or 1,
		fg = fg or "#FFFFFF",
		bg = bg or "#000000",
	}

	local private = {
		percentage = 0,
	}

	obj.__index = term_module

	function obj:update_pos(x, y)
		self.origin_x = x == nil and self.origin_x or x
		self.origin_y = y == nil and self.origin_y or y
	end

	function obj:dispear()
		term_module:filling_rectangle(self.origin_x, self.origin_y, self.width, self.height, self.bg)
	end

	function obj:move_to(x, y)
		self:dispear()
		self:update_pos(x, y)
		self:render(private.percentage)
	end

	function obj:render(percentage)
		private.percentage = (percentage >= 0 and percentage <= 100) and percentage
			or error("persontage should be in the range of 0 to 100")
		term_module:render_color(self.fg, self.bg)
		local bar_width = math.floor((self.width - 2) * percentage / 100)
		term_module:move_to(self.origin_x + 1, self.origin_y)
		io.write(string.rep("█", bar_width))
		io.write(string.rep(" ", self.width - 2 - bar_width))
		term_module:reset_color()
	end

	function obj:stirb()
		self:dispear()
		-- self = nil
	end

	return setmetatable(obj, term_module)
end

-- function term_module:bottom_bar()
--- set the size as un updated, so that the next operation could get the newest values

function term_module:start_operation()
	self:update_term_size()
end

function term_module:end_operation()
	self.size.updated = false
	io.flush()
end

return term_module
