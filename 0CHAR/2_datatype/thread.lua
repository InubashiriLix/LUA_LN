local co = coroutine.create(function()
	print("Hello from coroutine")
end)

print(type(co))

-- resume the coroutine
coroutine.resume(co)

-- yield the coroutine
local co1 = coroutine.create(function()
	for i = 1, 10 do
		print("i", i)
		coroutine.yield()
	end
end)
coroutine.resume(co1)
coroutine.resume(co1)
coroutine.resume(co1)

print(coroutine.status(co1))
print(type(coroutine.status(co)))

-- wraping the coroutine in a functions
local co2 = coroutine.wrap(function()
	for i = 1, 10 do
		print("i", i)
		coroutine.yield()
	end
end)

co2()
co2()
co2()
co2()
