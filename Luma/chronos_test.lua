local Scheduler = require("src.chronos")

-- 创建调度器
local scheduler = Scheduler:new()

-- 添加高优先级任务
scheduler:add_task(function(s)
	for i = 1, 3 do
		print("High-priority task running, iteration:", i)
		s:sleep(2)
	end
end, 1)

-- 添加低优先级任务
scheduler:add_task(function(s)
	for i = 1, 5 do
		print("Low-priority task running, iteration:", i)
		s:sleep(1)
	end
end, 2)

-- 运行调度器
scheduler:run()
