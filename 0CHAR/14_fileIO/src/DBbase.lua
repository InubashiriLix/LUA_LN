FILE_PATH = "db.csv"
DEBUG = true

local logger = function(msg, ...)
	if DEBUG then
		print(msg, ...)
	end
end

local isFileExist = function(file_relative_path)
	local file = io.open(file_relative_path, "r")
	if file == nil then
		return false
	else
		file:close()
		return true
	end
end

local function create_file(file_relative_path)
	local file = io.open(file_relative_path, "r")
	if file == nil then
		file = io.open(file_relative_path, "w+")
	end
	if file ~= nil then
		file:close()
	end
end

local function DBInit()
	logger("initializing DB")
	while not isFileExist(FILE_PATH) do
		logger("file not exist, creating file")
		create_file(FILE_PATH)
	end
	logger("file exists, initializing DB")
end

local module_dbbase = {}

module_dbbase.FILE_PATH = FILE_PATH
module_dbbase.DBInit = DBInit

return module_dbbase
