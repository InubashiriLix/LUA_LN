local file_data_module = {}

file_data_module.lfs = require("lfs")

file_data_module.file_data = {
	["file_type"] = "", -- 文件类型，例如 "text", "image", "video", "directory" 等
	["file_name"] = "", -- 文件名，带扩展名
	["file_extension"] = "", -- 文件扩展名，例如 "txt", "jpg", "mp4" 等
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

function file_data_module:new(file_abs_path)
	if file_abs_path == nil or type(file_abs_path) ~= "string" then
		error("file_abs_path is required and must be a string")
	end
	local data = self.lfs.attribute(file_abs_path)
	if data == nil then
		error("file is not exists")
	end
end

return file_data_module
