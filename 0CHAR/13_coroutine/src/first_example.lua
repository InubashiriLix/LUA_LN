Module_first = {}

local function coroutine_test1()
	print("the coroutint_test start")
	-- pause the execution of the function using coroutine.yield
	coroutine.yield("pause for a while now from coroutine_test1")
	print("resuming! from coroutine_test1")
	print("END of coroutine_test1")
end

local function main()
	local co = coroutine.create(coroutine_test1)
	for i = 1, 10 do
		if i == 1 or i == 5 then
			coroutine.resume(co)
		end
	end
end

Module_first.coroutine_test1 = coroutine_test1
Module_first.main = main

return Module_first
