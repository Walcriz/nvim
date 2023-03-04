-- Settings for lazy.nvim plugin manager

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	defaults = {
		lazy = true,
		version = false,
	},
	install = { colorscheme = { "monokai"} },
	checker = { enabled = true }, -- Auto check for plugin updates
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		}
	}
})
