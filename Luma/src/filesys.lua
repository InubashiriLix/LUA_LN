local file_system_module = {}
local lfs = require("lfs")

--- tell whether the file exists
--- @param abs_path string
--- @return boolean
function file_system_module.file_exists(abs_path)
	local attr = lfs.attributes(abs_path)
	return attr ~= nil
end

---tell whether the path is a folder
---@param abs_path string
---@return boolean
function file_system_module.is_file(abs_path)
	local attr = lfs.attributes(abs_path, "mode")
	return attr == "file"
end

--- create a new folder
--- @param folder_name string the folder name
--- @return boolean, string -- success -> bollean, err -> string
function file_system_module:create_folder(folder_name)
	local success, err = lfs.mkdir(folder_name)
	return success, err
end

--- create a file
--- @param file_name string the file name
--- @return boolean, string?
function file_system_module:create_file(file_name)
	local file, err = io.open(file_name, "w")
	if file then
		file:close()
		return true, nil
	else
		-- print("file created")
		return false, err
	end
end

--- Use the absolute path to get file list
--- @param abs_path string the absolute path
--- @return table?: files and folders, or nil if empty
function file_system_module.load_files(abs_path)
	local files = {}
	for file in lfs.dir(abs_path) do
		if file ~= "." and file ~= ".." then
			table.insert(files, file)
		end
	end
	if #files == 0 then
		return nil -- Return nil if there are no files/folders
	end
	table.sort(files)
	return files
end

--- Use the absolute path to get the parent folder's absolute path
--- @param abs_path string the absolute path
--- @return string: the parent folder's absolute path
function file_system_module.get_parent_folder(abs_path)
	-- Regex for path separator handling
	local pattern = "(.-)[/\\][^/\\]*$" -- This matches both '/' and '\\' as path separators
	return string.match(abs_path, pattern)
end

--- Get all files and folders in the same level as the given directory (sibling directories)
--- @param abs_path string the absolute path
--- @return table?: sibling files and folders, or nil if empty
function file_system_module.get_sibling_files(abs_path)
	local parent_folder = file_system_module.get_parent_folder(abs_path)
	if not parent_folder then
		return nil
	end
	return file_system_module.load_files(parent_folder)
end

--- Get files and folders inside the given directory, or return nil if it's not a directory
--- @param abs_path string the absolute path
--- @return table?: files and folders, or nil if not a directory or empty
function file_system_module.get_child_folder_files(abs_path)
	-- Check if the path is a directory first
	local attr = lfs.attributes(abs_path)
	if not attr or attr.mode ~= "directory" then
		return nil -- Return nil if it's not a directory
	end
	return file_system_module.load_files(abs_path)
end

return file_system_module
