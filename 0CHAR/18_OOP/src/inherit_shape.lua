local Shape = {}

function Shape:new(width, height)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	obj:init(width, height)
	return obj
end

function Shape:init(width, height)
	assert(type(width) == "number" or type(height) == "number", "width and height must be numbers")
	assert(width > 0 and height > 0, "width and height must be greater than 0")
	self.width = width
	self.height = height
end

function Shape:Area()
	return self.width * self.height
end

function Shape:Info()
	print("Width: " .. self.width)
	print("Height: " .. self.height)
	print("Area: " .. self:Area())
end

return Shape
