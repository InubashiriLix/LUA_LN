local text_box_static = require("src.text_box_static")
local term = require("src.terminator")

term.clear()

--- Helper function to delay rendering for better visual testing
local function delay_render()
	os.execute("sleep 0.5") -- Adjust the delay as needed
end

--- Create and test multiple instances
local function test_text_boxes()
	-- Box 1: All parameters provided
	local box1 = text_box_static:new(
		"Hello\nLua\nThis is a static text box",
		2,
		2,
		"#FF0000",
		"#000000",
		20,
		5,
		true,
		false,
		true
	)
	box1:render()
	delay_render()

	-- Box 2: Border disabled, rounded corners enabled
	local box2 = text_box_static:new(
		"Static Text Box\nWith Rounded Corners",
		10,
		8,
		"#00FF00",
		"#000000",
		25,
		6,
		false,
		true,
		true
	)
	box2:render()
	delay_render()

	-- Box 3: Minimal dimensions (height and width are null, auto-calculated)
	local box3 = text_box_static:new("Minimal Box", 30, 12, "#FFFFFF", "#0000FF", nil, nil, true, false, true)
	box3:render()
	delay_render()

	-- -- Box 4: Text only (other parameters null/default)
	-- local box4 = text_box_static:new("Default Box", nil, nil, nil, nil, nil, nil, true, false, true)
	-- box4:render()
	-- delay_render()
	--
	-- -- Box 5: Testing long text truncation
	-- local box5 = text_box_static:new(
	-- 	"This is a very long text that exceeds the box width",
	-- 	40,
	-- 	18,
	-- 	"#FFAA00",
	-- 	"#111111",
	-- 	15,
	-- 	4,
	-- 	true,
	-- 	false,
	-- 	true
	-- )
	-- box5:render()
	-- delay_render()
	--
	-- Update Box 1: Change position and color
	box1:dispear()
	box1:update_pos(5, 5)
	box1:update_color("#0000FF", "#FF00FF")
	box1:update_text("Updated Box 1\nWith New Text")
	box1:render()
	delay_render()

	-- Update Box 2: Change size and border
	box2:update_size(30, 8)
	box2:update_border(true)
	box2:render()
	delay_render()

	-- Update Box 3: Change text and auto-size
	box3:update_text("Auto-sized box updated\nWith new content!")
	box3:update_size(nil, nil)
	box3:render()
	delay_render()

	-- -- Update Box 5: Expand size to fit text
	-- box5:update_size(40, 5)
	-- box5:render()
	-- delay_render()
end

test_text_boxes()
