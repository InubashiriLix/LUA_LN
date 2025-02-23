local file_system_module = {}

--- use the abs path to get file list
--- @param abs_path string the absolute path
function file_system_module.load_files(abs_path)
	local files = {}
	for file in lfs.dir("abs_path") do
		if file ~= "." and file ~= ".." then
			table.insert(files, file)
		end
	end
	table.sort(files)
	return files
end

--- use the abs path to get parent folder abs path
--- @param abs_path string the absolute path
--- @turn table: parent shit
function file_system_module.get_parent_folder(abs_path)
	-- regex fucking
	local pattern1 = "^(.+)//"
	local pattern2 = "^(.+)\\"

	if string.match(abs_path, pattern1) == nil then
		return string.match(abs_path, pattern2)
	else
		return string.match(abs_path, pattern1)
	end
end

--- just a quick api for load files
function file_system_module.get_child_folder_files(abs_path)
	return file_system_module.load_files(abs_path)
end

return file_system_module
