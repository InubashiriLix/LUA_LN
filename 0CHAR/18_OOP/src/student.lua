Student = {}

function Student:new(name, age)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	obj:init(name, age)
	return obj
end

function Student:init(name, age)
	assert(type(name) == "string" or type(age) == "number", "Invalid parameters")
	assert(age >= 0, "Invalid age")
	assert(#name >= 0, "Invalid name")
	self.name = name
	self.age = age
end

function Student:printHello()
	print("Hello World")
end

function Student:greeting(str)
	print("Hello " .. str)
end

function Student:getName()
	return self.name
end

return Student
