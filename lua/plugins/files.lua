local Util = require("util")

return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		keys = {
			{ "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
			{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			-- find
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "ff", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
			{ "FF", Util.telescope("files"), desc = "Find Files (root dir)" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
			-- git
			{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
			-- search
			{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
			{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
			{ "fg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
			{ "<leader>sG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
			{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
			{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
			{ "<leader>sw", Util.telescope("grep_string", { disable_devicons = true }), desc = "Word (root dir)" },
			{
				"<leader>sW",
				Util.telescope("grep_string", { cwd = false, disable_devicons = true }),
				desc = "Word (cwd)",
			},
			{
				"<leader>uC",
				Util.telescope("colorscheme", { enable_preview = true }),
				desc = "Colorscheme with preview",
			},
			{
				"<leader>ss",
				Util.telescope("lsp_document_symbols", {
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
					},
				}),
				desc = "Goto Symbol",
			},
			{
				"<leader>sS",
				Util.telescope("lsp_workspace_symbols", {
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
					},
				}),
				desc = "Goto Symbol (Workspace)",
			},
		},
		opts = {
			defaults = {
				mappings = {
					i = {
						["<c-t>"] = function(...)
							return require("trouble.providers.telescope").open_with_trouble(...)
						end,
						["<a-t>"] = function(...)
							return require("trouble.providers.telescope").open_selected_with_trouble(...)
						end,
						["<a-f>"] = function()
							Util.telescope("find_files", { no_ignore = true })()
						end,
						["<a-h>"] = function()
							Util.telescope("find_files", { hidden = true })()
						end,
						["<a-n>"] = function()
							Util.telescope_extensions("file_browser", { hidden = true })()
						end,
						["<C-Down>"] = function(...)
							return require("telescope.actions").cycle_history_next(...)
						end,
						["<C-Up>"] = function(...)
							return require("telescope.actions").cycle_history_prev(...)
						end,
						["<C-f>"] = function(...)
							return require("telescope.actions").preview_scrolling_down(...)
						end,
						["<C-b>"] = function(...)
							return require("telescope.actions").preview_scrolling_up(...)
						end,
					},
					n = {
						["q"] = function(...)
							return require("telescope.actions").close(...)
						end,
					},
				},

				vimgrep_arguments = {
					"rg",
					"-L",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
				},
				prompt_prefix = " ",
				selection_caret = " ",
				entry_prefix = "  ",
				initial_mode = "insert",
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "bottom",
						preview_width = 0.52,
						results_width = 0.8,
					},
					vertical = {
						mirror = false,
					},
					width = 0.87,
					height = 0.80,
					preview_cutoff = 120,
				},
				path_display = { "truncate" },
				winblend = 0,
				border = {},
				-- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				borderchars = { "▄", "▌", "▀", "▐", "▗", "▖", "▘", "▝" },
				color_devicons = true,
				set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
			},
			highlight = { enable = true },
		},

		config = function(_, opts)
			local telescope = require("telescope")

			local defaults = {}
			if vim.fn.has("win32") ~= 1 then
				local images = require("util").telescope_image_preview()
				defaults = {
					file_previewer = images.file_previewer,
					buffer_previewer_maker = images.buffer_previewer_maker,
				}
			end

			telescope.setup({
				extensions = {
					file_browser = {
						-- disables netrw and use telescope-file-browser in its place
						hijack_netrw = true,
					},
					harpoon = {},
					project = {},
				},
				defaults = vim.tbl_extend('force', opts.defaults, defaults),
			})

			telescope.load_extension("project")
			-- telescope.load_extension("file_browser")
			-- telescope.load_extension("harpoon")
		end,

		dependencies = {
			-- "nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-project.nvim",
			-- "ThePrimeagen/harpoon",
		},
	},

	-- File browser
	-- {
	-- 	"nvim-telescope/telescope-file-browser.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	keys = { -- Telescope file_browser path=" .. Util.get_root()
            -- -- stylua: ignore
	-- 		{ "fn", function() vim.cmd("Telescope file_browser path=" .. Util.get_root() .. " hidden=true") end, desc = "File Browser" },
	-- 		{ "fN", "<cmd>Telescope file_browser path=%:p:h hidden=true<cr>", desc = "File Browser" },
	-- 	},
	-- 	lazy = true,
	-- },

	{
		'stevearc/oil.nvim',
		opts = {
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name, bufnr)
					return vim.startswith(name, '..')
				end
			},
		},
		keys = {
			{ "fn", "<cmd>Oil<CR>", desc = "File browser" },
			{ "FN", "<cmd>Oil %:p:h<CR>", desc = "File browser" },
		},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
	},

	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		keys = {
			{ "<leader>tt", function() require("nvim-tree.api").tree.open() end, desc = "File browser" },
		},

		opts = {
			reload_on_bufenter = true,
			filters = {
				custom = { "^.git$" }
			},
		},

		config = function(_, opts)
			require("nvim-tree").setup(opts)

			vim.api.nvim_create_autocmd("QuitPre", {
				callback = function()
					local invalid_win = {}
					local wins = vim.api.nvim_list_wins()
					for _, w in ipairs(wins) do
						local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
						if bufname:match("NvimTree_") ~= nil then
							table.insert(invalid_win, w)
						end
					end
					if #invalid_win == #wins - 1 then
						-- Should quit, so we close all invalid windows.
						for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
					end
				end
			})

			local api = require("nvim-tree.api")
			api.events.subscribe(api.events.Event.FileCreated, function(file) vim.cmd("edit " .. file.fname) end)
		end
	},

	{
		"nvim-telescope/telescope-project.nvim",
		keys = {
			{ "<leader>sp", "<cmd>Telescope project<cr>", desc = "Project Browser" },
		},
		lazy = true,
	},
}
