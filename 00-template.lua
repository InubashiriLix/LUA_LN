-- create_template.lua
-- 一键创建项目模板工程结构 (使用 lfs 创建目录)
-- 使用方式：lua create_template.lua <project_name>
-- 若不指定 project_name 则默认 "my_project"

local lfs = require("lfs")

-- 获取项目名称
local project_name = arg[1] or "my_project"

-- 定义目录结构
local dirs = {
	project_name,
	project_name .. "/src",
}

-- 定义文件及内容
local files = {
	[project_name .. "/main.lua"] = [[
-- main.lua
local module = require("src.module")
print(module.hello())
]],

	[project_name .. "/src/module.lua"] = [[
-- module.lua
local M = {}

function M.hello()
    return "Hello from module!"
end

return M
]],

	[project_name .. "/.luarc.json"] = [[
{
    "Lua": {
        "runtime": {
            "version": "LuaJIT",
            "path": [
                "?.lua",
                "?/init.lua"
            ]
        },
        "workspace": {
            "checkThirdParty": false,
            "library": [
                "./src"
            ]
        },
        "diagnostics": {
            "globals": ["vim"]
        }
    }
}
]],
}

-- 创建目录函数（使用 lfs）
local function create_dir(path)
	local attr = lfs.attributes(path)
	if not attr then
		local ok, err = lfs.mkdir(path)
		if not ok then
			print("Failed to create directory: " .. path .. " Error: " .. tostring(err))
		else
			print("Created directory: " .. path)
		end
	else
		-- 如果已存在，不报错
		print("Directory already exists: " .. path)
	end
end

-- 创建文件并写入内容
local function create_file(path, content)
	local f, err = io.open(path, "w")
	if f then
		f:write(content)
		f:close()
		print("Created file: " .. path)
	else
		print("Failed to create file: " .. path .. " Error: " .. tostring(err))
	end
end

-- 创建目录结构
for _, d in ipairs(dirs) do
	create_dir(d)
end

-- 创建文件
for path, content in pairs(files) do
	create_file(path, content)
end

print("Project template created successfully in: " .. project_name)
print("You can now run:")
print("cd " .. project_name .. " && lua main.lua")
