local ffi = require("ffi")
local socket = require("socket")
local windows = require("src.windows")

local term = require("src.term_components.terminator")
local main = windows.init()

local function load_files()
	local files = {}
	for file in lfs.dir(".") do
		if file ~= "." and file ~= ".." then
			table.insert(files, file)
		end
	end
	table.sort(files)
	return files
end

local file_list = load_files()

ffi.cdef([[char nonblocking_input(void);]])
local lib = ffi.load("lib/libnonblocking_input.so")

local file_list_len = #file_list
local ptr_last = 0
local temp_w, temp_h = term.get_size()
local file_windows_text_list_height =
	math.min(math.floor(main.file_windows_config.height_ratio * temp_h) - 2, file_list_len)
-- local ptr_lower = math.floor(main.file_windows_config.height_ratio * temp_h) - 2 -- -2 means minus the border bar
local ptr_upper = 1
local ptr_lower = ptr_upper + file_windows_text_list_height - 1
local ptr_current = 1
local fun_scroll = nil
while true do
	if ptr_current ~= ptr_last then
		local file_text = ""
		for i, file_name in ipairs(file_list) do
			if i == ptr_current then
				file_text = file_text .. "> " .. file_name .. "\n"
			else
				file_text = file_text .. "  " .. file_name .. "\n"
			end
		end

		if fun_scroll then
			fun_scroll()
		end
		main:udpate(
			file_text,
			"test",
			"ptr_current: " .. ptr_current .. "\n" .. "ptr_upper: " .. ptr_upper .. "\n" .. "ptr_lower: " .. ptr_lower
		)

		ptr_last = ptr_current
	end
	-- socket.sleep(0.05)
	socket.sleep(0.01)
	--
	fun_scroll = nil

	local char = lib.nonblocking_input()

	local function scroll_up()
		-- ptr_current = (ptr_current == 1) and 1 or ptr_current - 1
		-- if ptr_current < ptr_upper then -- scroll up
		-- 	ptr_upper = ptr_current
		-- 	ptr_lower = ptr_lower - 3
		-- 	fun_scroll = function()
		-- 		main:scroll(-3)
		-- 	end
		-- end
		ptr_current = (ptr_current < 2) and 1 or ptr_current - 1
		if ptr_current <= ptr_upper then
			ptr_upper = math.max(1, ptr_upper - 3)
			ptr_lower = ptr_upper + file_windows_text_list_height - 1
			fun_scroll = function()
				main:scroll(-1)
				main:scroll(-1)
				main:scroll(-1)
				main:scroll(-1)
			end
		end
	end

	local function scroll_down()
		ptr_current = (ptr_current == file_list_len) and file_list_len or ptr_current + 1
		if ptr_current >= ptr_lower then -- scroll down
			-- ptr_upper = ptr_upper + 1
			-- ptr_lower = ptr_current
			ptr_lower = math.min(ptr_lower + 3, file_list_len)
			ptr_upper = ptr_lower - file_windows_text_list_height + 1
			fun_scroll = function()
				main:scroll(3)
			end
		end
		-- print("?Dowm")
		-- print("ptr_current: ", ptr_current)
		-- print("ptr_upper: ", ptr_upper)
		-- print("ptr_lower: ", ptr_lower)
	end

	if char == string.byte("j") then
		scroll_down()
	end

	if char == string.byte("k") then
		scroll_up()
	end

	if char == string.byte("q") then
		print("Quit")
		break
	end

	if char == 27 then -- 处理 Escape Sequences
		local next1 = lib.nonblocking_input()
		if next1 == 91 then
			-- print("detected [")
			local next2 = lib.nonblocking_input()
			if next2 == 65 then -- up
				scroll_up()
				-- print("detected A")
			elseif next2 == 66 then -- down
				scroll_down()
				-- print("detected B")
				-- elseif next2 == 67 then
				-- -- print("detected C")
				-- 	-- return "right"
				--                 --
				-- elseif next2 == 68 then
				-- -- print("detected D")
				-- 	-- return "left"
			end
		end
		-- elseif char == "\n" or char == "\r" then -- enter
		-- 	break
		-- elseif char == "\t" then -- tab
		-- 	-- return "Tab"
		-- elseif char == string.char(127) then
		-- 	-- return "BS"
		-- elseif char:byte() < 32 then
		-- 	-- return "C-" .. string.char(char:byte() + 96)
		-- else
		-- 	-- return char
	end
end
