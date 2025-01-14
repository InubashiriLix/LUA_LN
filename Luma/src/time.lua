local time_module = {}

-- ====================== attribute UTCtime_module START ==========================
time_module.get_current_time = function()
	return os.date("!%Y-%m-%dT %H:%M:%SZ")
end

local function create_field(name, min, max)
	local field = { value = 0 }

	function field:set(value)
		if value < min or value > max then
			error(name .. " must be between " .. min .. " and " .. max)
		end
		self.value = value
	end

	function field:get()
		return self.value
	end

	setmetatable(field, {
		__call = function()
			return field.value
		end,
	})

	return field
end

-- Define fields with respective ranges
time_module.Year = create_field("Year", 0, 9999)
time_module.Month = create_field("Month", 1, 12)
time_module.Day = create_field("Day", 1, 31)
time_module.Hour = create_field("Hour", 0, 23)
time_module.Minute = create_field("Minute", 0, 59)
time_module.Second = create_field("Second", 0, 59)

local function get_locale_time(locale)
	if locale ~= nil and (type(locale) ~= "number" or locale < -12 or locale > 14) then
		error("Invalid locale")
	end
	local utc_date = os.date("!*t")
	return utc_date.year + locale,
		utc_date.month + locale,
		utc_date.day + locale,
		utc_date.hour + locale,
		utc_date.min + locale,
		utc_date.sec + locale
end

local function update(instance)
	if instance == nil then
		error("instance can not be nil")
	end
	local utc_date = os.date("!*t")
	instance.Year:set(utc_date.year)
	instance.Month:set(utc_date.month)
	instance.Day:set(utc_date.day)
	instance.Hour:set(utc_date.hour)
	instance.Minute:set(utc_date.min)
	instance.Second:set(utc_date.sec)
end

function time_module:new_use_locale(locale)
	return time_module:new(get_locale_time(locale))
end

function time_module:new(year, month, day, hour, minute, second)
	local instance = {
		Year = create_field("Year", 0, 9999),
		Month = create_field("Month", 1, 12),
		Day = create_field("Day", 1, 31),
		Hour = create_field("Hour", 0, 23),
		Minute = create_field("Minute", 0, 59),
		Second = create_field("Second", 0, 59),
	}

	setmetatable(instance, {
		__index = self,
		__tostring = function()
			return string.format(
				"%04d-%02d-%02dT %02d:%02d:%02dZ",
				instance.Year(),
				instance.Month(),
				instance.Day(),
				instance.Hour(),
				instance.Minute(),
				instance.Second()
			)
		end,
	})

	if year and month and day and hour and minute and second then
		instance.Year:set(year)
		instance.Month:set(month)
		instance.Day:set(day)
		instance.Hour:set(hour)
		instance.Minute:set(minute)
		instance.Second:set(second)
	elseif not year and not month and not day and not hour and not minute and not second then
		update(instance)
	else
		error("Invalid arguments")
	end

	instance.update = function()
		update(instance)
	end

	return instance
end

-- ====================== attribute UTCtime_module END ==========================

return time_module
