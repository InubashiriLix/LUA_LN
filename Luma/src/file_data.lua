local file_data_module = {}

file_data_module.data_maps = require("file_data_maps")

file_data_module.lfs = require("lfs")

local file_data = {
	["file_name"] = "", -- 文件名，带扩展名
	["file_extension"] = "", -- 文件扩展名，例如 "txt", "jpg", "mp4" 等
	["mode"] = false, -- 是否为目录
	["file_type"] = "", -- 文件类型，例如 "text", "image", "video", "directory" 等
	["file_size"] = 0, -- 文件大小（以字节为单位）
	["file_size_readable"] = "", -- 可读的文件大小，例如 "1.2 KB", "3 MB"
	["file_last_modified"] = "", -- 文件最后修改时间（格式化字符串）
	["file_create_date"] = "", -- 文件创建时间（格式化字符串）
	["file_owner"] = "", -- 文件所有者
	["file_permissions"] = "", -- 文件权限，例如 "rwxr-xr-x"
	["is_hidden"] = false, -- 是否为隐藏文件
	["is_readable"] = true, -- 是否可读
	["is_writable"] = true, -- 是否可写
	["is_executable"] = false, -- 是否可执行
	["file_path"] = "", -- 文件的绝对路径
	["file_thumbnail"] = "", -- 缩略图路径（如果是图片或视频）
	["file_mime_type"] = "", -- 文件的 MIME 类型，例如 "text/plain", "image/jpeg"
	["file_hash"] = "", -- 文件的哈希值（如 MD5/SHA-1，用于校验文件）
	["file_tags"] = {}, -- 文件标签（用户自定义的一些分类标记）
}

--- get the file extension name
--- @param abs_file_path string the absolute file path
--- @retrun string | nil the extension name
function file_data_module:get_extension_name(abs_file_path)
	abs_file_path = abs_file_path:lower()
	local extension = abs_file_path:match("^.+%.(.+)$") or abs_file_path
	return extension
	-- NOTE: for the case like ".log" we use the special type in the file_data_maps.file_extension_types to tell
end

--- tell the type of the file
--- @param extension_name string the extension name of the file
--- @return string|nil return the file type if the extension name is matched, otherwise return nil
function file_data_module:telling_file_type(extension_name)
	extension_name = extension_name:lower()
	for type_name, type_map in pairs(self.data_maps.file_extension_types) do
		for _, ext in pairs(type_map) do
			if extension_name == ext then
				return type_name
			end
		end
	end
	return "unknown"
end

--- test function for telling the file type
--- @return nil
function file_data_module:test_tell_file_type()
	local test_cases = {
		{ "TXT", "text" },
		{ "jpg", "image" },
		{ "mp4", "video" },
		{ "mp3", "audio" },
		{ "zip", "archive" },
		{ "doc", "document" },
		{ "xls", "spreadsheet" },
		{ "ppt", "presentation" },
		{ "sql", "database" },
		{ "exe", "executable" },
		{ "ttf", "font" },
		{ "pdf", "pdf" },
		{ "html", "source_code" },
		{ "css", "source_code" },
		{ "js", "source_code" },
		{ "php", "source_code" },
		{ "java", "source_code" },
		{ "py", "source_code" },
		{ "c", "source_code" },
		{ "cpp", "source_code" },
		{ "h", "source_code" },
		{ "hpp", "source_code" },
		{ "rb", "source_code" },
		{ "html", "source_code" },
		{ "css", "source_code" },
		{ "js", "source_code" },
		{ "php", "source_code" },
		{ "ini", "settings" },
		{ "xml", "settings" },
		{ "json", "settings" },
		{ "bak", "backup" },
		{ "tmp", "temp" },
		{ "log", "log" },
		{ "vimrc", "config" },
		{ "unknown", "unknown" },
		{ "dir", "directory" },
	}
	for _, test_case in ipairs(test_cases) do
		local predicted_type = file_data_module:telling_file_type(test_case[1])
		if predicted_type == "unknown" then
			print("nil should be " .. test_case[2])
		elseif not (predicted_type == test_case[2]) then
			print("" .. test_case[1] .. " " .. predicted_type .. " should be " .. test_case[2])
		end
	end
end

--- @param file_abs_path string the absolute file path
--- @return string the name of the file
function file_data_module:get_file_name(file_abs_path)
	local file_name = file_abs_path:match("^.+/(.+)$") or file_abs_path
	return file_name
end

--- @param file_abs_path string the absolute file path
--- @return string the readable size of the file
function file_data_module:get_file_readable_size(file_abs_path)
	local file_size = self.lfs.attributes(file_abs_path).size
	local units = { "B", "KB", "MB", "GB", "TB" }
	local size = file_size
	local unit = 1
	while size >= 1024 do
		size = size / 1024
		unit = unit + 1
	end
	return string.format("%.2f %s", size, units[unit])
end

--- @param file_abs_path string the absolute file path
--- @return string the readable size of the file
function file_data_module:get_file_owner(file_abs_path)
	local file_last_modified = self.lfs.attributes(file_abs_path).modification
	return os.date("%Y-%m-%d %H:%M:%S", file_last_modified)
end

function file_data_module:new(file_abs_path)
	-- check the argument
	if file_abs_path == nil or type(file_abs_path) ~= "string" then
		error("file_abs_path is required and must be a string")
	end

	local file_attributes = self.lfs.attributes(file_abs_path)
	-- check whether the file has been exists
	if file_attributes == nil then
		error("file is not exists")
	end

	-- create a new obj in order to retrun them
	local obj = {}
	obj.data = file_data

	-- the file name
	obj.data.file_name = self:get_file_name(file_abs_path)

	-- the file extension
	obj.data.file_extension = self:get_extension_name(file_abs_path)

	-- mode
	obj.data.data.mode = file_attributes.mode

	-- type
	obj.data.file_type = self:telling_file_type(obj.file_extension)

	-- file size readable
	obj.data.file_size_readable = file_attributes.size

	-- file owner

	-- return obj
	--
end

function file_data_module:stirb() end

-- obj = file_data_module:new("/home/orangepi/test.txt")

-- return file_data_module
-- file_data_module.test_tell_file_type()
-- print(file_data_module.lfs.attributes("/root/llvm.sh").size)
-- print(file_data_module.lfs.attributes("/root/llvm.sh").mode)
-- print(file_data_module.lfs.attributes("/root/llvm.sh").dev)
-- print(file_data_module.lfs.attributes("/root/llvm.sh").uid)
-- print(file_data_module.lfs.attributes("/root/llvm.sh").gid)
