local windows = {}
local config = require("src.config")

local log_prefix = "[windows] "

local term = require("src.term_components.terminator")
local text_box_dynamic = require("src.term_components.text_box_dynamic")
local text_box_static = require("src.term_components.text_box_static")
local border_syms = require("src.term_components.border_sym")

local schemes = require("src.scheme")

local scheme = schemes[config.settings.scheme]
local scheme_mode = config.settings.scheme_mode
--
-- print(scheme)
-- print(scheme_mode)

function windows.init()
	local self = {}

	local width, height = term.get_size()
	if width < 60 and height < 10 then
		error("too small to display")
	end

	self.file_windows_config = {
		x = 0,
		y = 0,
		width_ratio = 0.7,
		height_ratio = 0.7,
	}

	self.file_windows = text_box_dynamic:new(
		self.file_windows_config.x,
		self.file_windows_config.y,
		math.floor(width * self.file_windows_config.width_ratio),
		math.floor(height * self.file_windows_config.height_ratio),
		scheme.fg.scheme_mode,
		scheme.bg.scheme_mode,
		true,
		true,
		true
	)

	self.file_windows:update_border_sym("tr", border_syms.td)

	self.info_windows_config = {
		x = 0,
		y = math.floor(height * self.file_windows_config.height_ratio),
	}

	self.info_windows = text_box_dynamic:new(
		self.info_windows_config.x,
		self.info_windows_config.y,
		math.floor(width * self.file_windows_config.width_ratio),
		height + 1 - math.floor(height * self.file_windows_config.height_ratio),
		scheme.fg.scheme_mode,
		scheme.bg.scheme_mode,
		true,
		true,
		true
	)

	self.info_windows:update_border_sym("tl", border_syms.lr)
	self.info_windows:update_border_sym("tr", border_syms.lf)
	self.info_windows:update_border_sym("br", border_syms.tu)

	self.view_windows_config = {
		x = math.floor(width * self.file_windows_config.width_ratio),
		y = 0,
	}

	self.view_windows = text_box_dynamic:new(
		self.view_windows_config.x,
		self.view_windows_config.y,
		width - math.floor(width * self.file_windows_config.width_ratio),
		height,
		scheme.fg.scheme_mode,
		scheme.bg.scheme_mode,
		true,
		true,
		true
	)
	--- the windows should be static
	function self:udpate(file_text_new, info_text_new, view_text_new)
		-- TODO: check the whether the size has changed
		if view_text_new then
			self.view_windows:update_text(view_text_new)
			self.view_windows:render()
		end
		if file_text_new then
			-- local temp_type = type(file_text_new)
			-- if temp_type == "table" then
			-- elseif temp_type == "string" then
			self.file_windows:update_text(file_text_new)
			-- end
			self.file_windows:render()
		end

		if info_text_new then
			self.info_windows:update_text(info_text_new)
			self.info_windows:render()
		end

		term:move_to(0, 0)
	end

	function self:scroll(num)
		self.file_windows:update_offset_y(num)
	end

	return setmetatable(self, { __index = windows })
end

return windows
