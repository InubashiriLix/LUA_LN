test1 = require("src.test")

local variable1 = 1
local variable2 = "test"
local variable1 = false

test1.test()
-- debug.debug()
tt = debug.getfenv(variable1)
debug.debug()
