local queue_module = {}

local settings = require("settings")

queue_module.LogQueue = {}
queue_module.LogQueue.queue = {}
queue_module.LogQueue.queue_max_size = 100

function queue_module.LogQueue:add(func)
	local new_index = #queue_module.LogQueue.queue + 1
	if new_index > self.queue_max_size then
		if settings.STRICT then
			error("the queue is full")
		end
	else
		table.insert(self.queue, coroutine.create(func))
	end
end

-- may be this could be the main function in the future
function queue_module.LogQueue:run()
	while #queue_module.LogQueue.queue > 0 do
		local co = table.remove(queue_module.LogQueue.queue, 1)
		coroutine.resume(co)
	end
end

setmetatable(queue_module.LogQueue, {
	__index = function(self, key)
		return self.queue[key]
	end,
	__newindex = function(self, key, value)
		-- self.queue[key] = value
		error("the new index is not avaliable, please use the add method")
	end,
})

return queue_module
