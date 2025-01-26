local Scheduler = {}

function Scheduler:new()
	local obj = {
		tasks = {},
		time = 0,
		time_slice = 1,
	}
	self.__index = self
	return setmetatable(obj, self)
end

function Scheduler:add_task(func, priority, delay)
	priority = priority or 1
	delay = delay or 0
	local task = {
		id = #self.tasks + 1,
		priority = priority,
		state = "ready",
		coroutine = coroutine.create(func),
		wake_time = self.time + delay,
	}

	if not self.tasks[priority] then
		self.tasks[priority] = {}
	end

	table.insert(self.tasks[priority], task)
	return task.id
end

function Scheduler:remove_task(task_id)
	for priority, queue in pairs(self.tasks) do
		for i, task in ipairs(queue) do
			if task.id == task_id then
				table.remove(queue, i)
				return true
			end
		end
	end
	return false
end

function Scheduler:run()
	while true do
		local found_task = false

		-- iterate all the priority queues
		for priority = 1, #self.tasks do
			local queue = self.tasks[priority]
			if queue then
				local i = 1
				while i <= #queue do
					local task = queue[i]
					if task.state == "ready" and task.wake_time <= self.time then
						found_task = true
						local success, message = coroutine.resume(task.coroutine, self)
						if not success then
							-- print("Task error: ", message)
							table.remove(queue, i)
						elseif coroutine.status(task.coroutine) == "dead" then
							-- print("Task finished and removed.")
							table.remove(queue, i)
						else
							-- if the tasks is still need to be run, then re-schedule it
							-- print("Re-scheduling task...")
							table.insert(queue, table.remove(queue, i))
						end
						-- update the time_slice
						self.time = self.time + self.time_slice
					elseif task.state == "waiting" and task.wake_time <= self.time then
						-- print("Waking up waiting task...")
						task.state = "ready"
						i = i + 1 -- check the next task
					else
						i = i + 1 -- if the task is not ready, then check the next task
					end
				end
			end
		end

		-- if this round does not find any ready task, then check the waiting task
		if not found_task then
			for _, queue in pairs(self.tasks) do
				for _, task in ipairs(queue) do
					if task.state == "waiting" then
						found_task = true
						break
					end
				end
				if found_task then
					break
				end
			end
		end

		-- if there is no task that is ready or waiting, then do nothing
		if not found_task then
			print("No tasks to run, Scheduler exiting")
			-- break
		end
	end
end

function Scheduler:sleep(delay)
	local current_task = coroutine.running()
	for priority, queue in pairs(self.tasks) do
		for _, task in ipairs(queue) do
			if task.coroutine == current_task then
				task.state = "waiting"
				task.wake_time = self.time + delay
				coroutine.yield()
				task.state = "ready"
				return
			end
		end
	end
	error("Scheduler:sleep() called from a non-task context")
end

return Scheduler
