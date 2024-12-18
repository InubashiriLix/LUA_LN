function functional1(n)
	if n == 0 then
		return 1
	else
		return n * functional1(n - 1)
	end
end

factorial = functional1

print(factorial(5))

-- lambda functions
function testFun(tab, fun)
	for k, v in pairs(tab) do
		print(fun(k, v))
	end
end

table = { key1 = "val1", key2 = "val2" }
testFun(table, function(k, v)
	return k .. " = " .. v
end)

function saying(tab, fun)
	for _, v in pairs(tab) do
		print(fun(v))
	end
end

last = { "TAKE", "RESPONSIBILITY" }

saying(last, function(v)
	return "he said: " .. v
end)
