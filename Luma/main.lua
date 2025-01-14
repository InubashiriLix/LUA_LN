local windows_module = require("src.windows")
local helper_module = require("src.helper")
local time_module = require("src.time")
print("windows_module")

print(windows_module.Size.columns())
print(windows_module.Size.rows())

local time = time_module:new()
print(time)
print(time_module.get_current_time())
