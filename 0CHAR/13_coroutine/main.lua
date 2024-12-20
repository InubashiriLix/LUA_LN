local first = require("src.first_example")
local second = require("src.second_example")
local third = require("src.third_example")

first.main()

-- running two coroutines at the same time
second.co2()
while coroutine.status(second.co1) == "suspended" do
	coroutine.resume(second.co1, 100)
end

third.main()
