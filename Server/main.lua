local lfs = require("lfs")
local socket = require("socket")
local cjson = require("cjson")

local os = require("os")
local io = require("io")

local filesys = require("src.filesys")

local UPLOAD_DIR = "upload"
local ENCRYPTED_DIR = "encrypted"
local SECRET_KEY = "test_secret_ksy"
local SECRET_IV = "1234567890123456"

local UPLOADED_FILENAME = "todolist.txt"

local PORT = 8081

local function setup_dir()
	filesys.mkdir_pwd(UPLOAD_DIR, true)
	filesys.mkdir_pwd(ENCRYPTED_DIR, true)
end

setup_dir()

-- start the server
local server = assert(socket.bind("*", PORT))
local ip, port = server:getsockname()
print("Server running at http://" .. ip .. ":" .. port)

while true do
	local client = server:accept()
	client:settimeout(60)

	local request, err = client:receive("*1")
	if not err then
		print("Recieved request:" .. request)

		if request:find("POST /upload") then
			local body, err_client = client:receive("*a")
			if not err_client then
				local raw_file = UPLOAD_DIR .. "/" .. UPLOADED_FILENAME
				local encrypted_file = ENCRYPTED_DIR .. "/" .. UPLOADED_FILENAME .. ".enc"

				local f = io.open(raw_file, "wb")
				if f == nil then
					error("[main: write f]: open file failed")
				end
				f:write(body)
				f:close()

				-- TODO: encrypt the file using AES-256-CBC
				-- os.execute(
				-- 	string.format(
				-- 		"openssl enc -aes-256-cbc -salt -pbkdf2 -in %s -out %s -pass pass:%s -iv %s",
				-- 		raw_file,
				-- 		encrypted_file,
				-- 		SECRET_KEY,
				-- 		SECRET_IV
				-- 	)
				-- )
				client:send("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nFile uploaded and encrypted.\r\n")
			else
				client:send("HTTP/1.1 400 Bad Request\r\n\r\nFailed to read file.\r\n")
			end
		elseif request:find("GET /download") then
			local encrypted_file = ENCRYPTED_DIR .. "/" .. UPLOADED_FILENAME .. ".enc"
			local decrypted_file = ENCRYPTED_DIR .. "/" .. UPLOADED_FILENAME
			local f, f_read_err = io.open(encrypted_file, "rb")
			if f_read_err or f == nil then
				error("[send file]: open file failed, error: " .. f_read_err)
			end
			-- TODO: decrept the file is need there
			local data = f:read("*a")
			f:close()

			client:send("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n" .. data)
			os.remove(decrypted_file)
		elseif request:find("GET /files") then
			local files = filesys.ls_pwd(ENCRYPTED_DIR)
			local response = ""
			if #files == 0 then
				response = "the file list is empty \n"
			else
				for _, output_filename in ipairs(files) do
					response = "file list:\n" .. output_filename .. "\n"
				end
			end
			client:send("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n" .. response)
		else
			client:send("HTTP/1.1 400 Bad Request\r\n\r\nUnsupported request.\r\n")
		end
	else
		client:send("HTTP/1.1 400 Bad Request\r\n\r\nFailed to read request.\r\n")
	end
end
