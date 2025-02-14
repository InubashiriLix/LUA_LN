local scheme_module = {}

local molokai = {
	["background_c"] = "#1c1c1c",
	["background"] = "#1c1c1c",
	["foreground"] = "#f8f8f2",
	["cursor"] = "#f8f8f2",
	["selection"] = "#49483e",
	["selection_c"] = "#49483e",
	["black_c"] = "#1c1c1c",
	["red_c"] = "#f92672",
	["green_c"] = "#a6e22e",
	["yellow_c"] = "#fd971f",
	["blue_c"] = "#66d9ef",
	["magenta_c"] = "#ae81ff",
	["cyan_c"] = "#a1efe4",
	["white_c"] = "#f8f8f2",
	["bright_black_c"] = "#75715e",
	["bright_red_c"] = "#f92672",
	["bright_green_c"] = "#a6e22e",
	["bright_yellow_c"] = "#e6db74",
	["bright_blue_c"] = "#66d9ef",
	["bright_magenta_c"] = "#ae81ff",
	["bright_cyan_c"] = "#a1efe4",
	["bright_white_c"] = "#f8f8f2",
}

local ayu = {
	["bg"] = { ["dark"] = "#0F1419", ["light"] = "#FAFAFA", ["mirage"] = "#212733" },
	["comment"] = { ["dark"] = "#5C6773", ["light"] = "#ABB0B6", ["mirage"] = "#5C6773" },
	["markup"] = { ["dark"] = "#F07178", ["light"] = "#F07178", ["mirage"] = "#F07178" },
	["constant"] = { ["dark"] = "#FFEE99", ["light"] = "#A37ACC", ["mirage"] = "#D4BFFF" },
	["operator"] = { ["dark"] = "#E7C547", ["light"] = "#E7C547", ["mirage"] = "#80D4FF" },
	["tag"] = { ["dark"] = "#36A3D9", ["light"] = "#36A3D9", ["mirage"] = "#5CCFE6" },
	["regexp"] = { ["dark"] = "#95E6CB", ["light"] = "#4CBF99", ["mirage"] = "#95E6CB" },
	["string"] = { ["dark"] = "#B8CC52", ["light"] = "#86B300", ["mirage"] = "#BBE67E" },
	["function"] = { ["dark"] = "#FFB454", ["light"] = "#F29718", ["mirage"] = "#FFD57F" },
	["special"] = { ["dark"] = "#E6B673", ["light"] = "#E6B673", ["mirage"] = "#FFC44C" },
	["keyword"] = { ["dark"] = "#FF7733", ["light"] = "#FF7733", ["mirage"] = "#FFAE57" },
	["error"] = { ["dark"] = "#FF3333", ["light"] = "#FF3333", ["mirage"] = "#FF3333" },
	["accent"] = { ["dark"] = "#F29718", ["light"] = "#FF6A00", ["mirage"] = "#FFCC66" },
	["panel"] = { ["dark"] = "#14191F", ["light"] = "#FFFFFF", ["mirage"] = "#272D38" },
	["guide"] = { ["dark"] = "#2D3640", ["light"] = "#D9D8D7", ["mirage"] = "#3D4751" },
	["line"] = { ["dark"] = "#151A1E", ["light"] = "#F3F3F3", ["mirage"] = "#242B38" },
	["selection"] = { ["dark"] = "#253340", ["light"] = "#F0EEE4", ["mirage"] = "#343F4C" },
	["fg"] = { ["dark"] = "#E6E1CF", ["light"] = "#5C6773", ["mirage"] = "#D9D7CE" },
	["fg_idle"] = { ["dark"] = "#3E4B59", ["light"] = "#828C99", ["mirage"] = "#607080" },
}

scheme_module.molokai = molokai
scheme_module.ayu = ayu

return scheme_module
