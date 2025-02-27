local lfs = require("lfs")
local filesys = require("src.filesys")

local file = {}

WindowsFiles = {}
WindowsFiles.curr = nil
WindowsFiles.prev = nil
WindowsFiles.next = nil

DEBUG = 1

--- create a new file object,
--- if the abs_path is a folder, then the object's rele_files_list will be filled with the files in the folder
--- if the abs_path is a file, then the object's attris will be filled with the file's attributes, and the
--- rele_files_list will be a empty table
--- @param abs_file_path string
--- @return table
function file.new(abs_file_path)
	local obj = {}
	if DEBUG then
		print("initialize file in " .. abs_file_path)
	end

	if abs_file_path ~= nil and abs_file_path ~= "" then
		obj.abs_file_path = filesys.file_exists(abs_file_path) and abs_file_path
			or error("the file not exists: " .. abs_file_path)
		obj.is_folder = lfs.attributes(abs_file_path, "mode") == "directory"
		obj.attris = lfs.attributes(abs_file_path)
		obj.is_end = false
	else
		obj.rele_files_list = {}
		obj.is_end = true
	end

	if obj.is_folder then
		--- update the fils at the beginning
		obj.rele_files_list = filesys.get_child_folder_files(abs_file_path) or {}

		--- refresh the folder list
		function obj:refresh()
			-- check if the folder exists
			if not filesys.file_exists(abs_file_path) or lfs.attributes(abs_file_path, "mode") == "'directory" then
				-- go die
			end
			obj.rele_files_list = filesys.get_child_folder_files(abs_file_path) or {}
			obj.attris = lfs.attributes(abs_file_path)
		end

		--- return the table of files
		function obj:to_table()
			return obj.rele_files_list
		end

		--- get the child files (and the folders)
		--- @oaram abs_path number
		function obj:get_child_abs_path(idx)
			if self.rele_files_list ~= nil then
				return self.abs_file_path .. "/" .. self.rele_files_list[idx]
			end
		end

		function obj:get_parent_silblings()
			local parn_silblings = filesys.get_sibling_files(abs_file_path)
			if parn_silblings == nil then
				return {}
			else
				return parn_silblings
			end
		end

		function obj:get_parent_folder_name()
			return filesys.get_parent_folder(self.abs_file_path)
		end
	else -- NOTE: is a file
		function obj:refresh()
			if not filesys.get_child_folder_files(abs_file_path) or lfs.attributes(abs_file_path, "mode") == "file" then
				self.attris = lfs.attributes(abs_file_path)
				obj.rele_files_list = filesys.get_child_folder_files(abs_file_path) or {}
			end
		end
	end

	return setmetatable(obj, file)
end

function file:FileInit(enterpoint_folder_abs_path)
	-- check whether the checkpoint folder has been exists
	local temp_enterpoint = filesys.file_exists(enterpoint_folder_abs_path) and enterpoint_folder_abs_path or "/"
	-- check if the enterpoint is a folder
	temp_enterpoint = (not filesys.is_file(temp_enterpoint)) and temp_enterpoint
		or filesys.get_parent_folder(temp_enterpoint)

	-- then
	WindowsFiles.curr = file.new(temp_enterpoint)
	local temp_par_abs_path = filesys.get_parent_folder(WindowsFiles.curr.abs_file_path)
	WindowsFiles.prev = file.new(temp_par_abs_path)
	-- for index, item in ipairs(WindowsFiles.curr.files) do
	-- 	print(item)
	-- end
	WindowsFiles.next = file.new(WindowsFiles.curr:get_child_abs_path(1))
end

--- go to the selected (string) folder using the absolute path
---@param enter_abs_path_folder string
---@return boolean -- success or not
function file:FileNext(enter_abs_path_folder)
	-- if the current selected item is a folder, then you can go to the folder
	if not filesys.is_file(enter_abs_path_folder) then
		WindowsFiles.prev = WindowsFiles.curr
		WindowsFiles.curr = file.new(enter_abs_path_folder)
		WindowsFiles.next = file.new(WindowsFiles.curr:get_child_abs_path(1))
		return true
	end
	return false
end

--- go back to the parent folder
function file:FileBack()
	if WindowsFiles.prev.is_end == false then
		WindowsFiles.next = WindowsFiles.curr
		WindowsFiles.curr = self.new(WindowsFiles.curr:get_parent_folder_name())
		WindowsFiles.prev = self.new(WindowsFiles.prev:get_parent_folder_name())
	end
end

--- deprecated??
function file:FileRender()
	WindowsFiles.curr:refresh()
	WindowsFiles.next:refresh()
	WindowsFiles.prev:refresh()
	return WindowsFiles.prev.rele_files_list, WindowsFiles.curr.rele_files_list, WindowsFiles.next.rele_files_list
	-- return WindowsFiles.curr.files, WindowsFiles.next.files, WindowsFiles.prev.files
end

return file
