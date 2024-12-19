local a = 21
local b = 10
local c = a + b
print("Line 1 - c 的值为 ", c)
c = a - b
print("Line 2 - c 的值为 ", c)
c = a * b
print("Line 3 - c 的值为 ", c)
c = a / b
print("Line 4 - c 的值为 ", c)
c = a % b
print("Line 5 - c 的值为 ", c)
c = a ^ 2
print("Line 6 - c 的值为 ", c)
c = -a
print("Line 7 - c 的值为 ", c)

a = 5
b = 2

print("除法运算 - a/b 的值为 ", a / b)
-- NOTE: 整除运算符在Lua 5.3之后才有 以及LUAJIT 不让用
-- print("整除运算 - a//b 的值为 ", a // b)
print("取余运算 - a%b 的值为 ", math.floor(a, b))

a = 21
b = 10

if a == b then
	print("Line 1 - a 等于 b")
else
	print("Line 1 - a 不等于 b")
end

if a ~= b then
	print("Line 2 - a 不等于 b")
else
	print("Line 2 - a 等于 b")
end

if a < b then
	print("Line 3 - a 小于 b")
else
	print("Line 3 - a 大于等于 b")
end

if a > b then
	print("Line 4 - a 大于 b")
else
	print("Line 5 - a 小于等于 b")
end

-- 修改 a 和 b 的值
a = 5
b = 20
if a <= b then
	print("Line 5 - a 小于等于  b")
end

if b >= a then
	print("Line 6 - b 大于等于 a")
end

a = true
b = true

if a and b then
	print("a and b - 条件为 true")
end

if a or b then
	print("a or b - 条件为 true")
end

print("---------分割线---------")

-- 修改 a 和 b 的值
local a = false
local b = true

if a and b then
	print("a and b - 条件为 true")
else
	print("a and b - 条件为 false")
end

if not (a and b) then
	print("not( a and b) - 条件为 true")
else
	print("not( a and b) - 条件为 false")
end
