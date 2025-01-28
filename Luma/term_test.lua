local term_module = require("src.terminator")

-- 清屏
term_module:clear()

-- 延迟函数，用于观察效果
local function delay(seconds)
	os.execute("sleep " .. tonumber(seconds))
end

--- 测试 Box 类
local function test_box()
	print("Testing Box...")

	-- 创建一个 Box
	local box = term_module.components.box:new(5, 5, 20, 10, "#00FF00", "#000000", true, true, true)
	print("Rendering Box...")
	box:render()
	delay(1)

	-- 更新位置
	print("Moving Box to (10, 10)...")
	box:move_to(10, 10)
	delay(1)

	-- 隐藏 Box
	print("Disappearing Box...")
	box:dispear()
	delay(1)

	-- 再次渲染
	print("Re-rendering Box...")
	box:render()
	delay(1)

	-- 销毁 Box
	print("Destroying Box...")
	box:stirb()
	delay(1)
end

--- 测试 Progress Bar 类
local function test_progress_bar()
	print("Testing Progress Bar...")

	-- 创建一个 Progress Bar
	local progress_bar = term_module.components.progress_bar:new(10, 20, 30, 1, "#FF0000", "#000000")
	print("Rendering Progress Bar...")
	for i = 0, 100, 10 do
		progress_bar:render(i) -- 渲染进度条
		delay(0.5)
	end

	-- 移动 Progress Bar
	print("Moving Progress Bar to (15, 25)...")
	progress_bar:move_to(15, 25)
	for i = 0, 100, 20 do
		progress_bar:render(i)
		delay(0.5)
	end

	-- 隐藏 Progress Bar
	print("Disappearing Progress Bar...")
	progress_bar:dispear()
	delay(1)

	-- 销毁 Progress Bar
	print("Destroying Progress Bar...")
	progress_bar:stirb()
end

--- 主函数：运行测试
local function main()
	-- 清屏
	term_module:clear()

	-- 测试 Box
	test_box()

	-- 测试 Progress Bar
	test_progress_bar()

	-- 恢复终端状态
	print("Tests completed.")
end

main()
