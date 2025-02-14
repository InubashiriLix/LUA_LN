local cjson = require("cjson")

local lfs = require("lfs")

local config_module = {}

local logging = require("src.log")

config_module.log_prefix = "[config_module] "

config_module.config_folder_abs_path = os.getenv("HOME") .. "/.config/Luma/"
config_module.config_json_name = "config.json"
config_module.config_json_abs_path = config_module.config_folder_abs_path .. config_module.config_json_name

config_module.settings = {}
config_module.settings.scheme = "ayu"
config_module.settings.scheme_mode = "dark"

--- Check whether the config JSON file exists
---@return boolean
function config_module:is_config_exist()
	local file = io.open(self.config_json_abs_path, "r")
	if file then
		file:close()
		return true
	end
	return false
end

--- Create the default config
---@return boolean
function config_module:create_default_config()
	logging:log_daily_append(self.log_prefix .. "create the default config")
	-- Check whether the config folder exists
	local temp_folder_info = lfs.attributes(self.config_folder_abs_path)
	-- If the config folder does not exist
	if temp_folder_info == nil then
		-- Then create the config folder
		if not lfs.mkdir(self.config_folder_abs_path) then
			error("Creating the config folder failed")
		end
	end

	-- Reopen the config folder after creating it (if we have it)
	temp_folder_info = lfs.attributes(self.config_folder_abs_path)

	-- If the config folder exists
	if temp_folder_info and temp_folder_info.mode == "directory" then
		logging:log_daily_append(self.log_prefix .. "creating default config file")
		-- Create the config file
		local file = io.open(self.config_json_abs_path, "w")
		if file == nil then
			error("Creating the config file failed")
		end
		file:write(cjson.encode(self.settings))
		file:close()
		return true
	end
	return false
end

--- Load and parse the JSON config into settings
function config_module:load_config_from_json()
	logging:log_daily_append(self.log_prefix .. "load config from json")
	local file = io.open(self.config_json_abs_path, "r")
	if file == nil then
		error("Open config file failed")
	end
	local content = file:read("*a")
	file:close()
	self.settings = cjson.decode(content)
end

function config_module:init()
	-- Initialize the log
	logging:init()
	logging:log_daily_append(self.log_prefix .. "initialize the config module")

	-- Check if the config file exists
	if not self:is_config_exist() then
		logging:log_daily_append(self.log_prefix .. "config file lost, create the default config")

		-- Create the default config
		if not self:create_default_config() then
			error(self.log_prefix .. "create default config failed")
		end
	end

	-- Else the config file exists or has been created
	logging:log_daily_append(self.log_prefix .. "config file is existed")

	-- Load the config file
	self:load_config_from_json()
end

return config_module
