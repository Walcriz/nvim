-- Set specific colorscheme options here
local palette = require("monokai").pro
palette.param = "#FFDDC3"
palette.const = "#D5D5D5"
palette.popupSel = "#353336"
palette.popup = "#1d1b1e"
palette.black = "#242730"
palette.black2 = "#292c35"
palette.darker_black = "#1f222b"

require("monokai").setup({
	palette = palette,
	custom_hlgroups = {
		-- Treesitter
		["@keyword.function"] = {
			fg = palette.pink,
			style = "italic",
		},
		Include = {
			fg = palette.pink,
		},
		["@include"] = {
			fg = palette.pink,
		},
		["@function"] = {
			fg = palette.green,
		},
		["@parameter"] = {
			fg = palette.param,
			style = "italic",
		},
		["@function.builtin"] = {
			fg = palette.aqua,
			style = "italic",
		},
		["@function.call"] = {
			fg = palette.green,
		},
		["@method"] = {
			fg = palette.green,
		},
		["@method.call"] = {
			fg = palette.green,
		},
		["@annotation"] = {
			fg = palette.aqua,
			style = "italic,bold",
		},
		["@attribute"] = {
			fg = palette.aqua,
			style = "italic,bold",
		},
		["@constructor"] = {
			fg = palette.green,
			style = "bold",
		},
		["@constant"] = {
			fg = palette.const,
		},
		["@character.special"] = {
			fg = palette.aqua,
			style = "italic,bold",
		},
		["@type"] = {
			fg = palette.purple,
			style = "bold",
		},
		Type = {
			fg = palette.purple,
			style = "bold",
		},
		Function = {
			fg = palette.green,
		},
		Constant = {
			fg = palette.const,
		},
		Label = {
			fg = palette.pink,
		},
		["@type.builtin"] = {
			fg = palette.pink,
		},
		["@variable.builtin"] = {
			fg = palette.pink,
			style = "bold",
		},

		-- Git
		GitGutterAdd = {
			fg = palette.green,
		},
		GitGutterChange = {
			fg = palette.aqua,
		},
		GitGutterDelete = {
			fg = palette.red,
		},
		GitGutterChangeDelete = {
			fg = palette.red,
		},

		-- Rainbow
		TSRainbow1 = {
			fg = "#FFD865",
		},
		TSRainbow2 = {
			fg = "#AB9DF2",
		},
		TSRainbow3 = {
			fg = "#67ACB5",
		},

		LightlineLeft_active_tabsel = {
			fg = "#abb2bf",
			bg = "#3e4452",
		},

		-- Popup menu
		PmenuSel = {
			bg = palette.popupSel,
		},

		Pmenu = {
			bg = palette.popup,
		},

		-- Telescope
		TelescopeBorder = {
			fg = palette.darker_black,
		},

		TelescopePromptBorder = {
			fg = palette.black2,
		},

		TelescopePromptNormal = {
			fg = palette.white,
			bg = palette.black2,
		},

		TelescopePromptPrefix = {
			fg = palette.red,
			bg = palette.black2,
		},

		TelescopeNormal = { bg = palette.darker_black },

		TelescopePreviewTitle = {
			fg = palette.black,
			bg = palette.green,
		},

		TelescopePromptTitle = {
			fg = palette.black,
			bg = palette.red,
		},

		TelescopeResultsTitle = {
			fg = palette.black,
			bg = palette.aqua,
		},

		TelescopeSelection = { bg = palette.black2, fg = palette.white },

		TelescopeResultsDiffAdd = {
			fg = palette.green,
		},

		TelescopeResultsDiffChange = {
			fg = palette.yellow,
		},

		TelescopeResultsDiffDelete = {
			fg = palette.red,
		},

		-- Which key
		WhichKeyFloat = {
			bg = palette.darker_black,
		},

		-- Float menus
		NormalFloat = {
			bg = palette.darker_black,
		},
	},
})

vim.cmd([[
hi Normal guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
]])

-- Configure Rainbow Delimiters
