A = 10
print(type(A))

A = "this is A test"
print(type(A))

A = true
print(type(A))

A = false
print(type(A))

A = nil
print(type(A))
-- this should be "nil"

print(type(type(print)))
-- this should be "string"

print(type(print))
-- this should be "function"

-- table
table = { key1 = "one", key2 = "two", key3 = "three" }
print(table.key1)
