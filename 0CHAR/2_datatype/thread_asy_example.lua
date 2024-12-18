-- async_programing

local function async_task()
	print("Start task")
	coroutine.yield()
	print("Task resumed")
end

local co = coroutine.create(async_task)
coroutine.resume(co)
coroutine.resume(co)

-- generater
local function range(n)
	for i = 1, n do
		coroutine.yield(i)
	end
end

local co = coroutine.create(function()
	range(5)
end)

while coroutine.status(co) ~= "dead" do
	local success, value = coroutine.resume(co)
	print(success)
	print(value)
end
