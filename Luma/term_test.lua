local term_module = require("src.terminator")

local function run_tests()
	print("Starting tests for term_module...")

	-- 1. Test clear function
	print("Testing clear...")
	term_module.clear()

	-- 2. Test terminal size fetching
	print("Testing get_size...")
	local cols, rows = term_module.get_size()
	assert(cols > 0 and rows > 0, "Terminal size fetching failed")
	print("Terminal size:", cols, "cols x", rows, "rows")

	-- 3. Test cursor movement
	print("Testing cursor movement...")
	-- term_module.move_to(term, 5, 5)
	term_module.print_at(5, 5, "Cursor test passed!", "#FFFFFF", "#0000FF")

	-- 4. Test horizontal line
	print("Testing horizontal_line...")
	term_module:horizontal_line(10, 10, 20, "#FF0000", "#000000")

	-- 5. Test vertical line
	print("Testing vertical_line...")
	term_module:vertical_line(15, 12, 5, "#00FF00", "#000000")

	-- 6. Test box (border + filling)
	print("Testing box with filling...")
	term_module:box(20, 15, 30, 10, "#FFFF00", "#0000FF", true, false, true)

	-- 7. Test rounded box
	print("Testing rounded box...")
	term_module:box(60, 15, 20, 8, "#FF00FF", "#000000", true, true, false)

	-- 8. Test progress bar
	print("Testing progress bar...")
	local progress = term_module:progress_bar(10, 25, 40, 1, "#00FFFF", "#000000")
	for i = 0, 100, 10 do
		progress(i)
		os.execute("sleep 0.2") -- Simulate progress
	end

	-- 9. Test reset color
	print("Testing reset_color...")
	term_module.reset_color()

	-- 10. Test start and end operations
	print("Testing start_operation and end_operation...")
	term_module:start_operation()
	term_module:end_operation()

	print("All tests passed!")
end

run_tests()
