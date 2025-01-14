local file_data_module = {}

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
	["file_encode_type"] = "", -- 文件编码类型，例如 "UTF-8", "ASCII"
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
  local extension = abs_file_path:match("^.+%.(.+)$")
  return extension
end

print(file_data_module:get_extension_name("/home/orangepi/test.txt"))
print(file_data_module:get_extension_name("/home/orangepi/test"))

function file_data_module:telling_file_type()

end


function file_data_module:new(file_abs_path)
	-- check the argument
	if file_abs_path == nil or type(file_abs_path) ~= "string" then
		error("file_abs_path is required and must be a string")
	end

	local data = self.lfs.attributes(file_abs_path)
	-- check whether the file has been exists
	if data == nil then
		error("file is not exists")
	end

	-- create a new obj in order to retrun them
	local obj = {}

  -- the file name
  obj.file_name = data.

  -- the file extension
  obj.file_extension = data.extension

	-- get the file datas
	obj.file_data = file_data
	-- mode
	obj.data.mode = data.mode
  -- type 
  obj.data.file_type = 

	return obj
end

function file_data_module:stirb() end

obj = file_data_module:new("/home/orangepi/test.txt")

return file_data_module
