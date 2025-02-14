local ayu = require("src.scheme").molokai
local text_box_dynamic = require("src.term_components.text_box_dynamic")
local term = require("src.term_components.terminator")

-- 清屏
term.clear()

-- 初始化一个小尺寸的文本框
local text_box = text_box_dynamic:new(1, 1, 20, 5, ayu["white_c"], ayu["background"], true, false, true)

-- 设置多行文本
text_box:update_text([[
First Line
Second Line
Third Line
Fourth Line
Fifth Line
Sixth Line
Seventh Line
]])

-- 渲染初始状态
text_box:render()

-- 模拟滚动
local function scroll_demo()
	for _ = 1, 4 do
		os.execute("sleep 0.5") -- 延迟 0.5 秒
		text_box:update_offset_y(1) -- 向下滚动
		term.clear()
		text_box:render()
	end

	for _ = 1, 4 do
		os.execute("sleep 0.5") -- 延迟 0.5 秒
		text_box:update_offset_y(-1) -- 向上滚动
		term.clear()
		text_box:render()
	end
end

scroll_demo()
