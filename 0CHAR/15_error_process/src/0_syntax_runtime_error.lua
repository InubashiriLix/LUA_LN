--  the syntax error is like this:
--  src/0_syntax_runtime_error.lua:1: '=' expected near 'module_error_1'
--

-- the runtime errors are the error that will be thrown when the code is running
-- like

local function devide(a, b)
	assert(type(a) == "number", "a must be a number")
	assert(type(b) == "number", "b must be a number")
	if b == 0 then
		-- error("b can not be 0")
		-- error("b can not be 0", 1) -- show where the error is (file + line index)
		error("b can not be 0", 2) --  show which function call the error
		-- error("b can not be 0", 0) -- do not show the stack trace
	end
	return a / b
end

local module_error_1 = {}

module_error_1.devide = devide

return module_error_1
