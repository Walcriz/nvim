-- Set specific colorscheme options here
local palette = require("monokai").pro

require("monokai").setup({
	palette = palette,
	custom_hlgroups = {
		-- Treesitter
		["@keyword.function"] = {
			fg = palette.pink,
			style = 'italic'
		},
		Include = {
			fg = palette.pink,
		},
		["@include"] = {
			fg = palette.pink,
		},
		["@function.builtin"] = {
			fg = palette.aqua,
			style = 'italic',
		},
		["@function.call"] = {
			fg = palette.green,
			style = 'italic',
		},
		-- Rainbow
		TSRainbow1 = {
			fg = "#FFD865"
		},
		TSRainbow2 = {
			fg = "#AB9DF2"
		},
		TSRainbow3 = {
			fg = "#67ACB5"
		},

		LightlineLeft_active_tabsel = {
			fg = "#abb2bf",
			bg = "#3e4452",
		}
	}
})

vim.cmd([[
hi Normal guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
]])

-- Configure Rainbow Delimiters
