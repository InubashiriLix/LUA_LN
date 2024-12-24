Member = {}

function Member:new(name, age, date, reason, level)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	obj:init(name, age, date, reason, level)
	return obj
end

function Member:init(name, age, date, reason, level)
	assert(
		type(name) == "string"
			or type(age) == "number"
			or type(date) == "string"
			or type(reason) == "string"
			or type(level) == "number",
		"Invalid parameters type"
	)
	assert(#name > 0, "Invalid name")
	assert(age >= 0, "Invalid age")
	assert(#date > 0, "Invalid date")
	assert(#reason > 0, "Invalid reason")
	assert(level > 0, "Invalid level")
	self.name = name
	self.age = age
	self.date = date
	self.reason = reason
	self.level = level

	print("good luck ... Mrs." .. self.name .. " ...")
	print("It will be hurt")
	print("You will not be missed")
	print("You own it, hahaha")
	print("STIRB! STIRB! SITRB!")
	print("GO HELL! YOU BASTARD!")
	print("I'm so glad that you are dead now, " .. self.name .. "! hahahahahahahahaha")
end

function Member:goHell()
	print(self.name .. " dead for " .. self.reason .. " on " .. self.date .. " at level " .. self.level)
	print("level " .. self.level .. " should be very painful")
	print("GO HELL! YOU BASTARD!")
	print("STIRB FUR MICH, SCHESSE")
	print("You own your own pain now!!!")
	print("Now you are dead, you will not be missed")
	print("I'll kill you again")
	print(
		"and I'll kill all of your family, your parents, your daughter, your son, your lover, and make my best to let them die through the painest way"
	)
	print("and They die painfully, all thanks to you.")
end

return Member
