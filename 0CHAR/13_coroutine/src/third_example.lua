Module_third = {}

local co1 = coroutine.wrap(function()
	-- simulate a long computation
	while true do
		local num = coroutine.yield()
		if num then
			local temp = 0
			print("processing with " .. num)
			for i = 1, num * 10 do
				temp = temp + i
			end
			print("result: " .. temp)
		end
	end
end)

local function main()
	while true do
		local pure_input = io.read()
		print("pure_input: " .. pure_input)
		local input = tonumber(pure_input)
		if input then
			co1(input)
		else
			print("please enter a number")
		end
		print("while done once")
	end
end

Module_third.main = main

return Module_third
