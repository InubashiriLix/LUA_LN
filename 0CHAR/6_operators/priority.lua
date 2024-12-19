-- this script sets the priority of the operator
--

-- first the ^ operator is set to the highest priority
print(2 ^ 3 * 4)
-- 32

-- second the not, - (unary)
-- print(not true * 1) it failed
print(4 * -1)
-- -4

-- then the * / %
-- then the + -
-- then comes the ..
print("dfasd" .. 123 + 123 % 1)

-- then the < > <= >= ~= ==
-- then the and or
