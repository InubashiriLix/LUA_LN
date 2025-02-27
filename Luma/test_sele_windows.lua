local ffi = require("ffi")
local lfs = require("lfs")
local socket = require("socket")
local windows = require("src.sele_windows")

local filesys = require("src.filesys")
local file = require("src.file")

local term = require("src.term_components.terminator")
local main = require("src.sele_windows")

term:clear()

windows = main.init()

-- initialize the enterpoint file path
local enterpoint_folder_abs_path = lfs.currentdir()
-- local enterpoint_folder_abs_path = "/"
file:FileInit(enterpoint_folder_abs_path)

-- local temp_prev_seles, temp_curr_seles, temp_next_seles = file:FileRender()
--
-- windows.file_curr_windows:filling_update_selections_text(temp_curr_seles)
-- windows.file_prev_windows:filling_update_selections_text(temp_prev_seles)
-- windows.file_prev_windows:filling_update_selections_text(temp_prev_seles)
windows.file_prev_windows:filling_update_selections_text(WindowsFiles.curr.rele_files_list)
windows.file_curr_windows:filling_update_selections_text(WindowsFiles.curr.rele_files_list)
windows.file_prev_windows:filling_update_selections_text(WindowsFiles.prev.rele_files_list)

if 0 then
	print("CURR")
	for _, item in ipairs(WindowsFiles.curr.rele_files_list) do
		print(item)
	end
	print("NEXT")
	if WindowsFiles.next.rele_files_list then
		for _, item in ipairs(WindowsFiles.next.rele_files_list) do
			print(item)
		end
	end
	print("PREV")
	for _, item in ipairs(WindowsFiles.prev.rele_files_list) do
		print(item)
	end
end

windows:render()

-- term:move_to(0, 0)
term:hide_cursor()

-- print(#windows.file_curr_windows.private.selections)
-- print(flag)

--- use the abs path to get file list

ffi.cdef([[char nonblocking_input(void);]])
local lib = ffi.load("lib/libnonblocking_input.so")

while true do
	local temp_view_info = "upper border: "
		.. windows.file_curr_windows.private.upper_border_idx
		.. "\ncurrent index: "
		.. windows.file_curr_windows.current_sele_index
		.. "\nbottom border: "
		.. windows.file_curr_windows.private.bottom_border_idx
		.. "\n"

	windows:update_view_win_text(temp_view_info)
	windows:render()

	socket.sleep(0.03)

	local char = lib.nonblocking_input()

	if char == string.byte("j") then
		windows.file_curr_windows:scroll(1)
		WindowsFiles.next = file.new(WindowsFiles.curr:get_child_abs_path(windows.file_curr_windows.current_sele_index))
		windows.file_next_windows:filling_update_selections_text(WindowsFiles.next.rele_files_list)
	end

	if char == string.byte("k") then
		windows.file_curr_windows:scroll(-1)
		WindowsFiles.next = file.new(WindowsFiles.curr:get_child_abs_path(windows.file_curr_windows.current_sele_index))
		windows.file_next_windows:filling_update_selections_text(WindowsFiles.next.rele_files_list)
	end
	if char == string.byte("l") then
		if
			file:FileNext(
				WindowsFiles.curr.abs_file_path
					.. "/"
					.. windows.file_curr_windows.private.selections[windows.file_curr_windows.current_sele_index].text
			)
		then
			windows.file_prev_windows:filling_update_selections_text(WindowsFiles.prev.rele_files_list)
			windows.file_prev_windows.current_sele_index = windows.file_curr_windows.current_sele_index
			windows.file_curr_windows:filling_update_selections_text(WindowsFiles.curr.rele_files_list)
			windows.file_curr_windows.current_sele_index = 1
			windows.file_next_windows:filling_update_selections_text(WindowsFiles.next.rele_files_list)
		end
	end

	if char == string.byte("h") then
		file:FileBack()
		windows.file_prev_windows:filling_update_selections_text(WindowsFiles.prev.rele_files_list)
		windows.file_curr_windows:filling_update_selections_text(WindowsFiles.curr.rele_files_list)
		windows.file_curr_windows.current_sele_index = 1
		windows.file_next_windows:filling_update_selections_text(WindowsFiles.next.rele_files_list)
		windows.file_next_windows.current_sele_index = 1
	end

	if char == string.byte("q") then
		term:clear()
		term:move_to(0, 0)
		print("    Luma Ist Gestorben")
		break
	end

	if char == 27 then -- 处理 Escape Sequences
		local next1 = lib.nonblocking_input()
		if next1 == 91 then
			-- print("detected [")
			local next2 = lib.nonblocking_input()
			if next2 == 65 then -- up
				windows.file_curr_windows:scroll(-1)
				-- print("detected A")
			elseif next2 == 66 then -- down
				windows.file_curr_windows:scroll(1)
			elseif next2 == 67 then
				-- return "right"
				file:FileNext(
					WindowsFiles.curr.abs_file_path
						.. "/"
						.. windows.file_curr_windows.private.selections[windows.file_curr_windows.current_sele_index].text
				)
				windows.file_prev_windows:filling_update_selections_text(WindowsFiles.curr.rele_files_list)
				windows.file_curr_windows:filling_update_selections_text(WindowsFiles.curr.rele_files_list)
				windows.file_prev_windows:filling_update_selections_text(WindowsFiles.prev.rele_files_list)
			elseif next2 == 68 then
				-- return "left"
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
