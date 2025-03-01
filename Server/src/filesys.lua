local lfs = require("lfs")
local filesys = {}

---return wheterh the file has been exists
---@param file_abs_name string
---@return boolean
function filesys.is_exists(file_abs_name)
	return io.open(file_abs_name, "r") ~= nil
end

---return whether the file has been existed in the current working dir
---@param file_name string
---@return boolean
function filesys.is_exists_pwd(file_name)
	return io.open(file_name, "r") ~= nil
end

---return whether the input abs path's file is an file or an dir
---@param file_abs_name string
---@return boolean
function filesys.is_file(file_abs_name)
	if not filesys.is_exists(file_abs_name) then
		error("[filesys.is_file function]: the input abs path file do not exists")
	end
	return lfs.attributes(file_abs_name, "mode") == "file"
end

---return whether the input rel path's file is an file or an dir
---@param file_name string
---@return boolean
function filesys.is_file_pwd(file_name)
	if filesys.is_exists_pwd(file_name) == false then
		error("[filesys.is_file_pwd function]: the input rel path file do not exists")
	end
	return lfs.attributes(file_name, "mode") == "file"
end

---create a dir using absolute path
---@param dir_abs_name string
---@param exists_ok boolean
---@return boolean or erorr
function filesys.mkdir(dir_abs_name, exists_ok)
	if not filesys.is_exists(dir_abs_name) then
		local state, err = lfs.mkdir(dir_abs_name)
		if state == true then
			return state
		else
			error(err)
		end
	else
		if not exists_ok then
			error("[filesys.create_dir] then")
		else
			return true
		end
	end
end

---create a dir in the current working dir
---@param dir_name string
---@param exists_ok boolean
---@return boolean or erorr
function filesys.mkdir_pwd(dir_name, exists_ok)
	if not filesys.is_exists(dir_name) then
		local state, err = lfs.mkdir(dir_name)
		if state == true then
			return state
		else
			error(err)
		end
	else
		if not exists_ok then
			error("[filesys.create_dir] then")
		else
			return true
		end
	end
end

---return the table of entered abs dir
---@param dir_abs_path string
---@return table
function filesys.ls(dir_abs_path)
	local files = {}
	local dir = lfs.dir(dir_abs_path)
	if dir ~= nil then
		for _, filename in dir do
			table.insert(files, filename)
		end
	end
	return files
end

---return the table that contains all the dir and files in the given reletive dir (in the current working path)
---@param dir_rel_path string
---@return table
function filesys.ls_pwd(dir_rel_path)
	local files = {}
	local dir = lfs.dir(dir_rel_path)
	if dir ~= nil then
		for _, filename in dir do
			table.insert(files, filename)
		end
	end
	return files
end

return filesys
