local Util = require("util")

return {
	-- search/replace in multiple files
	{
		"windwp/nvim-spectre",
        -- stylua: ignore
        keys = {
            { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
        },
	},

	-- Visual multi (multi cursors)
	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
	},

	-- Todo comments
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = { "BufReadPost", "BufNewFile" },
		config = true,
        -- stylua: ignore
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
            { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
            { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
            { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
        },
	},

	-- which-key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			plugins = { spelling = true },
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			local keymaps = {
      mode = { "n", "v" },
				{ "<leader><tab>", group = "tabs" },
				{ "<leader>b", group = "buffer" },
				{ "<leader>c", group = "code" },
				{ "<leader>d", group = "code actions" },
				{ "<leader>f", group = "file/find" },
				{ "<leader>g", group = "git" },
				{ "<leader>gh", group = "hunks" },
				{ "<leader>gp", group = "preview" },
				{ "<leader>n", group = "harpoon" },
				{ "<leader>o", group = "server actions" },
				{ "<leader>r", group = "quick refactorings" },
				{ "<leader>s", group = "search" },
				{ "<leader>t", group = "tools" },
				{ "<leader>u", group = "ui" },
				{ "<leader>w", group = "windows" },
				{ "<leader>x", group = "diagnostics/quickfix" },
				{ "[", group = "prev" },
				{ "]", group = "next" },
				{ "g", group = "goto" },
			}
			if Util.has("noice.nvim") then
				keymaps["<leader>sn"] = { name = "+noice" }
			end
			wk.add(keymaps)
		end,
	},

	-- Neogit
	{
		"NeogitOrg/neogit",
		-- commit = "0af5fc831989320a5c3dcf860c871e77e218085f",
		keys = {
			{ "<leader>gg", "<cmd>Neogit kind=split<CR>", desc = "Open neogit" },
		},
		opts = {},
		config = function(_, opts)
			require("neogit").setup(opts)
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
		},
	},

	-- Undotree
	{
		"mbbill/undotree",
		keys = {
			{ "<leader>tu", "<Cmd>UndotreeToggle<CR>", desc = "Toggle undo tree window" },
		},
	},

	-- GitSigns
	{
		"lewis6991/gitsigns.nvim",
		config = true,
		event = { "BufNewFile", "BufReadPost" },
	},

	-- Runner
	{
		"stevearc/overseer.nvim",
		event = "VeryLazy",
		config = true
	},

	-- Auto save
	{
		"okuuva/auto-save.nvim",
		version = '^1.0.0',
		event = "VeryLazy",
		opts = {
			enabled = true,
			debounce_delay = 1000,
			condition = function(buf)
				-- Only save if buffer is modified
				return vim.api.nvim_buf_get_option(buf, "modified")
			end,
			write_all_buffers = true,
			noautocmd = true
		}
	},
}
