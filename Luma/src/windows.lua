local module_windows = {}

local function get_terminal_size()
	-- 获取行数（高度）
	local handle_rows = io.popen("tput lines")
	if not handle_rows then
		return 0, 0
	end
	local rows = handle_rows:read("*a")
	handle_rows:close()

	-- 获取列数（宽度）
	local handle_columns = io.popen("tput cols")
	if not handle_columns then
		return 0, 0
	end
	local columns = handle_columns:read("*a")
	handle_columns:close()

	return tonumber(rows), tonumber(columns)
end

-- ========================= attribute: Size START ========================

module_windows.Size = {}

module_windows.Size.columns = function()
	local _, columns = get_terminal_size()
	return columns
end

module_windows.Size.rows = function()
	local rows, _ = get_terminal_size()
	return rows
end

setmetatable(module_windows.Size, {
	__call = function(self)
		local rows, columns = get_terminal_size()
		return {
			rows = rows,
			columns = columns,
		}
	end,
	__index = function(self, key)
		if key == 1 then
			return self.Size.columns()
		elseif key == 2 then
			return self.Size.rows()
		end
	end,
	__newindex = function(self, key, value)
		error("Attempt to modify read-only table")
	end,
})

-- ========================= attribute: Size  END   =========================
--
--
--
-- ========================= function show_status_row  START =========================
-- module_windows.
-- ========================= function show_status_row   END  =========================

return module_windows
