local socket = require("socket")
-- local windows_module = require("src.windows")
-- local helper_module = require("src.helper")
-- local time_module = require("src.time")
-- print("windows_module")
--
-- print(windows_module.Size.columns())
-- print(windows_module.Size.rows())
--
-- local time = time_module:new()
-- print(time)
-- print(time_module.get_current_time())

-- test for log system
-- local log_module = require("src.log")
-- log_module:init()
-- log_module:log_append("test", log_module.log_type.DAILY_LOG)
-- log_module:log_append("test", log_module.log_type.DAILY_LOG)
-- socket.sleep(1)
-- log_module:log_append("test", log_module.log_type.DAILY_LOG)
-- log_module:log_append("test", log_module.log_type.DAILY_LOG)
-- log_module:log_append("test", log_module.log_type.DAILY_LOG)
-- log_module:log_append("test", log_module.log_type.DAILY_LOG)
-- log_module:log_append("test", log_module.log_type.DAILY_LOG)
-- log_module:log_append("test", log_module.log_type.DAILY_LOG)
-- log_module:log_append("test", log_module.log_type.DAILY_LOG)
--

-- test fore the qeue
-- local queue_module = require("src.queue")
-- local function test_queue()
-- 	print("test")
-- end
--
-- local test1 = coroutine.wrap(test_queue)
-- local test2 = coroutine.wrap(test_queue)
-- queue_module.LogQueue:add(test1)
-- queue_module.LogQueue:add(test2)
-- queue_module.LogQueue:run()
