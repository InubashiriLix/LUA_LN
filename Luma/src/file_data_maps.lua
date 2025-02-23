local file_data_maps = {}

file_data_maps.file_type_map = {
	["text"] = "text",
	["image"] = "img",
	["video"] = "video",
	["audio"] = "audio",
	["archive"] = "archive",
	["document"] = "document",
	["spreadsheet"] = "sheet",
	["presentation"] = "presentation",
	["database"] = "db",
	["executable"] = "exe",
	["font"] = "font",
	["pdf"] = "PDF",
	["source_code"] = "source_code",
	["web"] = "web",
	-- ["system"] = "system",
	["settings"] = "settings",
	["backup"] = "backup",
	["temp"] = "temp",
	["log"] = "log",
	["directory"] = "dirrectory",
	["unknown"] = "unknown",
}

file_data_maps.file_extension_types = {
	["text"] = { "txt" },
	{ "dir", "directory" },
	["image"] = { "jpg", "jpeg", "png", "gif", "bmp", "svg" },
	["video"] = { "avi", "mp4", "mkv", "flv", "mov", "wmv", "3gp" },
	["audio"] = { "mp3", "wav", "wma", "ogg", "flac", "aac" },
	["archive"] = { "zip", "rar", "7z", "tar", "gz", "bz2" },
	["document"] = { "doc", "docx", "odt", "pdf", "rtf", "tex" },
	["spreadsheet"] = { "xls", "xlsx", "ods", "csv" },
	["presentation"] = { "ppt", "pptx", "odp" },
	["database"] = { "sql", "sqlite", "db" },
	["executable"] = { "exe", "msi", "sh", "deb", "rpm" },
	["font"] = { "ttf", "otf", "fon", "fnt" },
	["pdf"] = { "pdf" },
	["source_code"] = {
		"html",
		"css",
		"js",
		"php",
		"java",
		"py",
		"c",
		"cpp",
		"h",
		"hpp",
		"rb",
		"html",
		"css",
		"js",
		"php",
	},
	["web"] = {},
	-- ["system"] = {"ini", "xml", "json", "md"},
	["settings"] = { "ini", "xml", "json" },
	["backup"] = { "bak", "backup", "swp" },
	["temp"] = { "tmp", "temp", "cache" },
	["log"] = { "log" },
	["directory"] = {},
	["config"] = { "vimrc", "bashrc" },
	["special"] = { "init.lua" },
	["unknown"] = {},
}
return file_data_maps
