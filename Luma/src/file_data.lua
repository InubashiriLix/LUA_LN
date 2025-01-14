local file_data_module = {}

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

file_data_module.file_type_map = {
	["text"] = "文本文件",
	["image"] = "图片文件",
	["video"] = "视频文件",
	["audio"] = "音频文件",
	["archive"] = "压缩文件",
	["document"] = "文档文件",
	["spreadsheet"] = "表格文件",
	["presentation"] = "演示文件",
	["database"] = "数据库文件",
	["executable"] = "可执行文件",
	["font"] = "字体文件",
	["pdf"] = "PDF 文件",
	["source_code"] = "源代码文件",
	["web"] = "网页文件",
	["system"] = "系统文件",
	["settings"] = "设置文件",
	["backup"] = "备份文件",
	["temp"] = "临时文件",
	["log"] = "日志文件",
	["directory"] = "文件夹",
	["unknown"] = "未知文件",
}

file_data_module.file_extension_types = {}

return file_data_module
