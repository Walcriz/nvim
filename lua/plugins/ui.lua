return {
	{
		"rcarriga/nvim-notify",
		keys = {
			{
				"<leader>un",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "Delete all Notifications",
			},
		},
		opts = {
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
		},
		init = function()
			vim.notify = require("notify")
		end,
	},

	-- better vim.ui
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},

	-- statusline
	{ -- TODO: Setup
		"itchyny/lightline.vim",
		config = function()
			vim.g.lightline = {
				colorscheme = "one",
				active = {
					left = {
						{ "mode", "paste" },
						{ "cocstatus", "currentfunction", "readonly", "buffers" }
					}
				},
				component_expand = {
					buffers = 'lightline#bufferline#buffers'
				},
				component_type = {
					buffers = 'tabsel'
				},
				component_function = {
					cocstatus = "coc#status",
					currentfunction = "CocCurrentFunction",
				}
			}
		end,
		lazy = false,
		dependencies = { "mengelbrecht/lightline-bufferline" },
	},

	{
		"mengelbrecht/lightline-bufferline",
		lazy = false,
	},
	-- TODO: Setup dashboard


	-- icons
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- ui components
	{ "MunifTanjim/nui.nvim", lazy = true },

	-- Rainbow brackets/delimiters
	{ "HiPhish/nvim-ts-rainbow2", lazy = true },
}
