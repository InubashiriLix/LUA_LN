local term = require("src.terminator")
local text_box_static = require("src.text_box_static")

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
	-- 调用父类的构造函数
	local obj = text_box_static:new("", origin_x, origin_y, fg, bg, width, height, border, rounded, filling)

	-- 私有属性
	local private = {
		text = "", -- 动态内容
		text_offset_x = 0, -- 水平偏移
		text_offset_y = 0, -- 垂直偏移
	}

	-- 私有方法：计算文本行
	local function compute_text_lines()
		local rtn_table = {}
		for line in private.text:gmatch("[^\r\n]+") do
			table.insert(rtn_table, line)
		end
		return rtn_table
	end

	-- 私有方法：计算最长行长度
	local function compute_line_max_len()
		local max_len = 0
		for _, line in ipairs(compute_text_lines()) do
			max_len = math.max(max_len, #line)
		end
		return max_len
	end

	-- 扩展公有方法

	--- 更新文本内容
	--- @param new_text string
	function obj:update_text(new_text)
		private.text = new_text or ""
		obj:update_size(obj.width, obj.height) -- 更新尺寸
	end

	--- 更新水平偏移
	--- @param dx number
	function obj:update_offset_x(dx)
		local max_offset = math.max(0, compute_line_max_len() - obj.num_max_show_width)
		private.text_offset_x = math.max(0, math.min(max_offset, private.text_offset_x + dx))
	end

	--- 更新垂直偏移
	--- @param dy number
	function obj:update_offset_y(dy)
		local max_offset = math.max(0, #compute_text_lines() - (self.border and (self.height - 2) or self.height))
		private.text_offset_y = math.max(0, math.min(max_offset, private.text_offset_y + dy))
	end

	--- 渲染动态文本框
	function obj:render()
		local lines = compute_text_lines()
		local text_abs_x = obj.origin_x + (obj.border and 1 or 0)
		local text_abs_y = obj.origin_y + (obj.border and 1 or 0)
		local text_max_width = self.border and self.width - 2 or self.width
		local num_lines = obj.border and obj.height - 2 or obj.height

		-- 渲染顶部边框
		if obj.border then
			term:move_to(obj.origin_x, obj.origin_y)
			local top_border = (obj.rounded and "╭" or "┌")
				.. string.rep("─", obj.width - 2)
				.. (obj.rounded and "╮" or "┐")
			io.write(top_border)
		end

		-- 渲染内容行
		for i = 1, num_lines do
			local line_index = private.text_offset_y + i
			local line = lines[line_index] or ""

			term:move_to(obj.origin_x, obj.origin_y + i)
			if obj.border then
				io.write("│") -- 左侧边框
			end

			-- 渲染行内容
			term:render_color(obj.fg, obj.bg)
			io.write(line:sub(private.text_offset_x + 1, private.text_offset_x + text_max_width))
			term:reset_color()

			-- 填充空白部分
			io.write(
				string.rep(
					" ",
					text_max_width - #line:sub(private.text_offset_x + 1, private.text_offset_x + text_max_width)
				)
			)

			if obj.border then
				io.write("│") -- 右侧边框
			end
		end

		-- 渲染底部边框
		if obj.border then
			term:move_to(obj.origin_x, obj.origin_y + obj.height - 1)
			local bottom_border = (obj.rounded and "╰" or "└")
				.. string.rep("─", obj.width - 2)
				.. (obj.rounded and "╯" or "┘")
			io.write(bottom_border)
		end

		io.flush()
	end

	return setmetatable(obj, { __index = self })
end

return text_box_dynamic
