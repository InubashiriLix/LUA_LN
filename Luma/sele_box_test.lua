local sele_box_module = require("src.term_components.sele_box")

-- NOTE: these code are for testing the sele_box module
--
-- local sele_box = sele_box_module.new(1, 1, 10, nil, nil, nil, nil, nil, true, true, true, true)
--
-- sele_box:append_selections("just a test", "#FFFFFF")
-- sele_box:append_selections("just a test", "#FFFFFF")
-- sele_box:append_selections("just a test", "#FFFFFF")
-- sele_box:append_selections("just a not a sd as ", "#FFFFFF")
-- sele_box:render()

-- --NOTE: these codes are for no autowidth
-- --
-- local sele_box = sele_box_module.new(1, 1, 10, nil, nil, nil, nil, nil, false, true, true, true)
--
-- sele_box:append_selections("just a test", "#FFFFFF")
-- sele_box:append_selections("just a test", "#FFFFFF")
-- sele_box:append_selections("just a test", "#FFFFFF")
-- sele_box:append_selections("just a not a sd as ", "#FFFFFF")
-- sele_box:render()

--- these code are for no border
local sele_box = sele_box_module.new(1, 1, 10, nil, nil, nil, nil, nil, true, false, true, true)

sele_box:append_selections("just a test", "#FFFFFF")
sele_box:append_selections("just a test", "#FFFFFF")
sele_box:append_selections("just a test", "#FFFFFF")
sele_box:append_selections("just a not a sd as ", "#FFFFFF")
sele_box:render()
