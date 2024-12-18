table = { "one", "two", "three" }

-- simple use
function operating(table, func)
	func(table)
end

operating(table, function(table)
	for i = 1, #table do
		print(table[i])
	end
end)

print("end of simple use of lambda")
