local ffi = require("ffi")
local lfs = require("lfs")
local socket = require("socket")
local windows = require("src.sele_windows")

local file_sys = require("src.filesys")

local term = require("src.term_components.terminator")
local main = require("src.sele_windows")

term:clear()

windows = main.init()

windows.file_prev_windows:append_sele_w("shit")
windows.file_prev_windows:append_sele_w("shit")
windows.file_prev_windows:append_sele_w("shit")
windows.file_next_windows:append_sele_w("shit1")
windows.file_next_windows:append_sele_w("shit1")
windows.file_next_windows:append_sele_w("shit1")

windows.file_curr_windows:append_sele_w("shit1")
windows.file_curr_windows:append_sele_w("shit2")
windows.file_curr_windows:append_sele_w("shit3")
windows.file_curr_windows:append_sele_w("shit4")
windows.file_curr_windows:append_sele_w("shit5")
windows.file_curr_windows:append_sele_w("shit6")
windows.file_curr_windows:append_sele_w("shit7")
windows.file_curr_windows:append_sele_w("shit8")
windows.file_curr_windows:append_sele_w("shit9")
windows.file_curr_windows:append_sele_w("shit10")
windows.file_curr_windows:append_sele_w("shit11")
windows.file_curr_windows:append_sele_w("shit12")
windows.file_curr_windows:append_sele_w("shit13")
windows.file_curr_windows:append_sele_w("shit14")
windows.file_curr_windows:append_sele_w("shit15")
windows.file_curr_windows:append_sele_w("shit16")
windows.file_curr_windows:append_sele_w("shit17")
windows.file_curr_windows:append_sele_w("shit18")
windows.file_curr_windows:append_sele_w("shit19")
windows.file_curr_windows:append_sele_w("shit20")
windows.file_curr_windows:append_sele_w("shit21")
windows.file_curr_windows:append_sele_w("shit22")
windows.file_curr_windows:append_sele_w("shit23")
windows.file_curr_windows:append_sele_w("shit24")
windows.file_curr_windows:append_sele_w("shit25")

windows.file_prev_windows:update_header("{ prev dir }")
windows.file_curr_windows:update_header("{ current dir }")
windows.file_next_windows:update_header("{ next dir view }")

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
	end

	if char == string.byte("k") then
		windows.file_curr_windows:scroll(-1)
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
				windows.file_curr_windows:scroll(-1)
				-- print("detected A")
			elseif next2 == 66 then -- down
				windows.file_curr_windows:scroll(1)
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
