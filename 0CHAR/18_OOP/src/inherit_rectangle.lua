Rectangle = {}

function Rectangle:new(...)
	local argc = select("#", ...)
	local height, width, o

	if argc == 2 then
		o = {}
		width = select(1, ...)
		height = select(2, ...)
	elseif argc == 3 then
		o = select(1, ...)
		width = select(2, ...)
		height = select(3, ...)
	end

	setmetatable(o, self)
	self.__index = self
	o:init(width, height)
	return o
end

function Rectangle:init(width, height)
	assert(type(width) == "number" or type(height) == "number", "width and height must be numbers")
	assert(width > 0 and height > 0, "width and height must be greater than 0")
	self.width = width
	self.height = height
end

function Rectangle:Area()
	return self.width * self.height
end

function Rectangle:Info()
	print("Width: " .. self.width)
	print("Height: " .. self.height)
	print("Area: " .. self:Area())
end

return Rectangle
