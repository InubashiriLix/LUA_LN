local log_module = {}
local lfs = require("lfs")
local settings = require("src.settings")

log_module.create_status = {
	["CREATE_SUCCESS"] = 1,
	["CREATE_EXISTS"] = 2,
	["CREATE_FAILED"] = 3,
}

log_module.log_ststus = {
	["NEW_LINE_ADDED_SUCCESS"] = 1,
	["NEW_LINE_ADDED_FAILD"] = 2,
}

log_module.log_type = {
	["DAILY_LOG"] = 1,
}

log_module.log_writing_flags = {
	["DAILY_LOG"] = false,
}

function log_module:in_log_type(log_type)
	for _, v in pairs(self.log_type) do
		if v == log_type then
			return true
		end
	end
	return false
end

function log_module:create_log_file(name, log_type)
	if name == nil or type(name) ~= "string" then
		error("name is required and must be a string")
	end

	-- check whether the log type exists
	if not self:in_log_type(log_type) then
		error("log type is invalid")
	end

	-- check whether the log file has been exists
	local file = io.open(settings.log_path .. name, "r")
	if file ~= nil then
		file:close()
		return self.create_status.CREATE_EXISTS
	end

	-- if the file does not exist create the log then create the log
	self.log_writing_flags[log_type] = true
	file = io.open(settings.log_path .. name, "w")
	if file == nil then
		self.log_writing_flags[log_type] = false
		error("create log file failed")
	end
	file:write("Log file created at " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n")
	file:close()
	self.log_writing_flags[log_type] = false
end

function log_module:daily_log_append_(name, content)
	self.log_daily_writing_flag = true
	-- appending mode for log file
	local file = io.open(settings.log_path .. name, "a")
	if file == nil then
		self.log_writing_flags.daily_log = false
		error("open file failed")
	end
	if content == nil or type(content) ~= "string" then
		self.log_writing_flags.daily_log = false
		error("content is required and must be a string")
	end
	-- then we confirm that the file has been exist
	self.log_writing_flags.daily_log = true
	local timestamp = os.date("%Y-%m-%d %H:%M:%S")
	file:write("\n[ " .. timestamp .. " ] " .. content)
	file:flush()
	file:close()
	self.log_writing_flags.daily_log = false
	return self.log_ststus.NEW_LINE_ADDED_SUCCESS
end

-- NOTE: use function to append the log
function log_module:log_append(content, log_type)
	-- TODO: What if the the date is changed when the log is appended?
	if log_type == self.log_type.DAILY_LOG then
		return self:daily_log_append_(os.date("%Y-%m-%d") .. ".log", content)
	end
	-- NOTE: please update there if new log type is added
end

--- append the content to the daily log file
--- @return boolean
function log_module:log_daily_append(content)
	local temp_log_write_state = self:log_append(content, self.log_type.DAILY_LOG)
	-- if not temp_log_write_state == self.log_ststus.NEW_LINE_ADDED_SUCCESS then
	-- 	error("daily log append failed")
	-- end
	return true
end

function log_module:init()
	-- check if the log_directory exists
	-- if not exists, then create the directory
	if lfs.attributes(settings.log_path) == nil then
		if not lfs.mkdir(settings.log_path) then
			error("create log dir failed")
		end
	end

	-- create the daily log file, if the file does not exist, then create it
	local date = os.date("%Y-%m-%d")
	local daily_log_name = date .. ".log"
	local create_status = self:create_log_file(daily_log_name, self.log_type.DAILY_LOG)
	if create_status == self.create_status["CREATE_FAILED"] then
		error("create log file failed")
	end
end

return log_module
