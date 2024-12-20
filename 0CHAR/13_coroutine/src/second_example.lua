Module_second = {}

co1 = coroutine.create(function(num)
	for i = 1, num do
		print("co1", i)
		if i % 10 == 0 then
			print(10)
			coroutine.yield()
			print(coroutine.status(co1))
			print(coroutine.running())
		elseif i % 30 == 0 then
			print(30)
			print(coroutine.status(co1))
			print(coroutine.running())
		end
	end
end)

co2 = coroutine.wrap(function()
	for i = 10, 20 do
		print("co2", i)
	end
end)

Module_second.co1 = co1
Module_second.co2 = co2

return Module_second
