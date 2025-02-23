local windows = {}

local config = require("src.config")
local logging = require("src.log")

local term = require("src.term_components.terminator")
local border_syms = require("src.term_components.border_sym")
local sele_box_module = require("src.term_components.sele_box")
local text_box_dynamic = require("src.term_components.text_box_dynamic")

local scheme = require("src.scheme")
local scheme_mode = config.settings.scheme_mode

function windows.init()
	local self = {}

	local width, height = term.get_size()
	if width < 60 and height < 10 then
		error("term too small to display")
	end

	self.file_prev_windows_settings = {
		x = 0,
		y = 0,
		width_ratio = 0.23,
		height_ratio = 0.7,
	}

	self.file_prev_windows = sele_box_module.new(
		self.file_prev_windows_settings.x,
		self.file_prev_windows_settings.y,
		math.floor(width * self.file_prev_windows_settings.width_ratio),
		math.floor(height * self.file_prev_windows_settings.height_ratio),
		scheme.ayu["fg"]["dark"],
		scheme.ayu["selection"]["dark"],
		nil,
		scheme.ayu["fg"]["dark"],
		scheme.ayu["bg"]["dark"],
		false,
		true,
		true,
		true
	)

	self.file_curr_windows_settings = {
		y = 0,
		width_ratio = 0.23,
		height_ratio = 0.7,
	}

	self.file_curr_windows = sele_box_module.new(
		math.floor(self.file_prev_windows_settings.width_ratio * width),
		self.file_curr_windows_settings.y,
		math.floor(self.file_curr_windows_settings.width_ratio * width),
		math.floor(height * self.file_curr_windows_settings.height_ratio),
		scheme.ayu["fg"]["dark"],
		scheme.ayu["selection"]["dark"],
		nil,
		scheme.ayu["fg"]["dark"],
		scheme.ayu["bg"]["dark"],
		false,
		true,
		true,
		true
	)

	self.file_next_windows_settings = {
		y = 0,
		width_ratio = 0.23,
		height_ratio = 0.7,
	}

	self.file_next_windows = sele_box_module.new(
		math.floor(self.file_curr_windows_settings.width_ratio * width)
			+ math.floor(self.file_next_windows_settings.width_ratio * width)
			- 1,
		self.file_next_windows_settings.y,
		math.floor(self.file_next_windows_settings.width_ratio * width) - 1,
		math.floor(height * self.file_next_windows_settings.height_ratio),
		scheme.ayu["fg"]["dark"],
		scheme.ayu["selection"]["dark"],
		nil,
		scheme.ayu["fg"]["dark"],
		scheme.ayu["bg"]["dark"],
		false,
		true,
		true,
		true
	)

	self.info_windows_settings = {
		x = 0,
		y = math.floor(height * self.file_next_windows_settings.height_ratio),
	}

	self.info_windows = text_box_dynamic:new(
		self.info_windows_settings.x,
		self.info_windows_settings.y,
		math.floor(width * self.file_prev_windows_settings.width_ratio)
			+ math.floor(width * self.file_curr_windows_settings.width_ratio)
			+ math.floor(width * self.file_next_windows_settings.width_ratio)
			- 3,
		height + 1 - math.floor(height * self.file_prev_windows_settings.height_ratio),
		scheme.ayu["fg"]["dark"],
		scheme.ayu["bg"]["dark"],
		true,
		true,
		true
	)

	self.view_windows_settings = {
		x = math.floor(width * self.file_prev_windows_settings.width_ratio) + math.floor(
			width * self.file_curr_windows_settings.width_ratio
		) + math.floor(width * self.file_next_windows_settings.width_ratio) - 3,
		y = 0,
	}

	self.view_windows = text_box_dynamic:new(
		self.view_windows_settings.x,
		self.view_windows_settings.y,
		width
			- (
				math.floor(width * self.file_prev_windows_settings.width_ratio)
				+ math.floor(width * self.file_curr_windows_settings.width_ratio)
				+ math.floor(width * self.file_next_windows_settings.width_ratio)
			),
		height,
		scheme.ayu["fg"]["dark"],
		scheme.ayu["bg"]["dark"],
		true,
		true,
		true
	)

	--- the windows should be static
	function self:update_text(info_text_new, view_text_new)
		-- TODO: check the whether the size has changed
		if info_text_new then
			self.info_windows:update_text(info_text_new)
			self.info_windows:render()
		end

		if view_text_new then
			self.view_windows:update_text(view_text_new)
			self.view_windows:render()
		end
		term:move_to(0, 0)
	end

	--- update the info window text
	--- @param new_text string? the new text to update
	function self:update_info_win_text(new_text)
		self.info_windows:update_text(new_text)
	end

	---- update the view windows text
	--- @param new_text string? the new text to update
	function self:update_view_win_text(new_text)
		self.view_windows:update_text(new_text)
	end

	--- append the new selection to the private.selections
	--- @param text string the text to append
	--- @param font_c string? the font color
	--- @param insert_pos number? the position to insert
	function self.file_curr_windows:append_sele_w(text, font_c, insert_pos)
		self:append_selections(text, font_c, insert_pos)
	end

	--- append the new selection to the private.selections
	--- @param text string the text to append
	--- @param font_c string? the font color
	--- @param insert_pos number? the position to insert
	function self.file_prev_windows:append_sele_w(text, font_c, insert_pos)
		self:append_selections(text, font_c, insert_pos)
	end

	--- append the new selection to the private.selections
	--- @param text string the text to append
	--- @param font_c string? the font color
	--- @param insert_pos number? the position to insert
	function self.file_next_windows:append_sele_w(text, font_c, insert_pos)
		self:append_selections(text, font_c, insert_pos)
	end

	self.info_windows:update_border_sym("tl", border_syms.lr)

	self.file_prev_windows:update_border_sym("tr", border_syms.td)
	self.file_prev_windows:update_border_sym("br", border_syms.tu)

	self.file_curr_windows:update_border_sym("tr", border_syms.td)
	self.file_curr_windows:update_border_sym("br", border_syms.tu)
	self.file_curr_windows:update_border_sym("bl", border_syms.tu)

	self.file_next_windows:update_border_sym("tr", border_syms.td)
	self.file_next_windows:update_border_sym("br", border_syms.lf)

	self.info_windows:update_border_sym("br", border_syms.tu)

	function self:render()
		self.view_windows:render()
		self.info_windows:render()
		self.file_next_windows:render()
		self.file_curr_windows:render()
		self.file_prev_windows:render()
		-- term:move_to(0, 0)
		term:hide_cursor()
	end

	return setmetatable(self, { __index = windows })
end

return windows
