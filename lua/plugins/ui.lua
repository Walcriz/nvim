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
			background_colour = "#000000",
		},
		init = function()
			vim.opt.termguicolors = true
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
	{
		"itchyny/lightline.vim",
		config = function()
			vim.g.lightline = {
				colorscheme = "one",
				active = {
					left = {
						{ "mode", "paste" },
						{ "readonly", "filename", "modified" },
						{ "lsp_info", "lsp_hints", "lsp_errors", "lsp_warnings", "lsp_ok", "lsp_status" },
					},
				},
			}
		end,
		lazy = false,
		dependencies = { "josa42/nvim-lightline-lsp" },
	},

	{
		"josa42/nvim-lightline-lsp",
		config = function()
			vim.cmd("call lightline#lsp#register()")
		end,
	},

	-- Dashboard
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		opts = function()
			local dashboard = require("alpha.themes.dashboard")
			local logo = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠲⠶⣶⣶⣤⣄⣀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣤⣄⠀⠀⠀⠀⠀⠀⠈⠙⢿⣿⣷⣦⡀⠀⠀⠀
⠀⠀⠀⠀⠀⢹⣿⣿⣦⣀⣀⣀⣠⣤⣤⣤⡽⢿⣿⣿⣦⡀⠀
⠀⠀⠀⠀⠀⢀⣿⣿⠿⠿⣿⣿⣿⣿⣿⡿⠀⠈⣿⣿⣿⣷⡀     ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
⠀⠀⠀⠀⠀⠸⢱⢹⣷⠞⢛⣿⣿⣿⡿⠁⠀⠀⢹⣿⣿⣿⣧     ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
⠀⠀⠀⠀⠀⢿⣾⣿⣇⡀⠧⢬⣿⣿⠁⠀⠀⠀⢸⣿⣿⣿⣿     ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
⡄⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⣿⣿⣿⣿⣿     ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
⢻⣄⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣦⡀⠀⠀⣼⣿⣿⣿⣿⡟     ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
⠈⢿⣦⣀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⡿⠁     ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
⠀⠈⠻⣿⣷⣶⣤⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀
⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠉⠙⠛⠿⠿⠿⠿⠿⠛⠋
			]]

			dashboard.section.header.val = vim.split(logo, "\n")
			dashboard.section.buttons.val = {
				dashboard.button("f", " " .. " Find file", ":Telescope find_files<CR>"),
				dashboard.button("n", " " .. " File browser", ":Telescope file_browser hidden=true<CR>"),
				dashboard.button("p", " " .. " Open project", ":Telescope project<CR>"),
				dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles<CR>"),
				dashboard.button("g", " " .. " Find text", ":Telescope live_grep disable_devicons=true<CR>"),
				dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
				dashboard.button(
					"s",
					" " .. " Restore Session",
					[[:lua require("persistence").load({ last = true }) <cr>]]
				),
				dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
			}
			for _, button in ipairs(dashboard.section.buttons.val) do
				button.opts.hl = "AlphaButtons"
				button.opts.hl_shortcut = "AlphaShortcut"
			end
			dashboard.section.footer.opts.hl = "Type"
			dashboard.section.header.opts.hl = "AlphaHeader"
			dashboard.section.buttons.opts.hl = "AlphaButtons"
			dashboard.opts.layout[1].val = 8
			return dashboard
		end,
		config = function(_, dashboard)
			-- close Lazy and re-open when the dashboard is ready
			if vim.o.filetype == "lazy" then
				vim.cmd.close()
				vim.api.nvim_create_autocmd("User", {
					pattern = "AlphaReady",
					callback = function()
						require("lazy").show()
					end,
				})
			end

			require("alpha").setup(dashboard.opts)

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyVimStarted", -- Comes from that this is a fork
				callback = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},

	-- icons
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		opts = {
			color_icons = false,
		},
		config = true,
	},

	-- ui components
	{
		"MunifTanjim/nui.nvim",
		lazy = true,
	},

	-- Rainbow brackets/delimiters
	{
		"HiPhish/nvim-ts-rainbow2",
		event = "VeryLazy",
	},
	-- { "p00f/nvim-ts-rainbow", lazy = true}

	-- Colorize colors
	{
		"NvChad/nvim-colorizer.lua",
		event = "VeryLazy",
	},
}
