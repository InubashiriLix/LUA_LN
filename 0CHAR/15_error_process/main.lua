runtime_error = require("src/0_syntax_runtime_error")

if pcall(runtime_error.devide, 1, 0) then
	print("no error")
else
	print("error")
end

if pcall(runtime_error.devide, 1, "0") then
	print("no error")
else
	print("error")
end

local function print_traceback(error)
	print("trace back:")
	print("error: " .. error)
end

local status = xpcall(runtime_error.devide, print_traceback, 1, 0)
print(status)
