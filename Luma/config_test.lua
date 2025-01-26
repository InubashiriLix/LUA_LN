local config_module = require("src.config")
local lfs = require("lfs")

--- Mock logging module for testing
local mock_log = {}

mock_log.log_daily_append = function(message)
	if type(message) == "string" then
		print("LOG: " .. message)
	else
		print("LOG: " .. tostring(message))
	end
end

mock_log.init = function()
	print("LOG: Initialized")
end
config_module.logging = mock_log

--- Test setup
local function setup()
	-- Create a test config folder path
	config_module.config_folder_abs_path = "./test_config/"
	config_module.config_json_abs_path = config_module.config_folder_abs_path .. config_module.config_json_name

	-- Ensure the test folder is clean
	if lfs.attributes(config_module.config_folder_abs_path) then
		os.execute("rm -rf " .. config_module.config_folder_abs_path)
	end
end

--- Test teardown
local function teardown()
	-- Clean up test config folder
	if lfs.attributes(config_module.config_folder_abs_path) then
		os.execute("rm -rf " .. config_module.config_folder_abs_path)
	end
end

--- Test case: is_config_exist should return false for missing config file
local function test_is_config_exist()
	print("Running test_is_config_exist")
	setup()
	assert(not config_module:is_config_exist(), "Expected config file to not exist")
	teardown()
end

--- Test case: create_default_config should create the config file
local function test_create_default_config()
	print("Running test_create_default_config")
	setup()
	assert(config_module:create_default_config(), "Expected create_default_config to succeed")
	assert(config_module:is_config_exist(), "Expected config file to exist after creation")
	teardown()
end

--- Test case: load_config_from_json should correctly load the default config
local function test_load_config_from_json()
	print("Running test_load_config_from_json")
	setup()
	config_module:create_default_config()
	config_module:load_config_from_json()
	assert(config_module.settings.scheme == "ayu", "Expected default scheme to be 'ayu'")
	teardown()
end

--- Test case: init should create and load config when none exists
local function test_init_creates_and_loads_config()
	print("Running test_init_creates_and_loads_config")
	setup()
	config_module:init()
	assert(config_module:is_config_exist(), "Expected config file to exist after init")
	assert(config_module.settings.scheme == "ayu", "Expected default scheme to be 'ayu' after init")
	teardown()
end

--- Run all tests
local function run_tests()
	test_is_config_exist()
	test_create_default_config()
	test_load_config_from_json()
	test_init_creates_and_loads_config()
	print("All tests passed!")
end

run_tests()
