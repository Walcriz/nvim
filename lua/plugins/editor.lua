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

	-- Super fast file movements
	-- {
	-- 	"ThePrimeagen/harpoon",
	-- 	keys = {
	-- 		{ "fö", "<cmd>Telescope harpoon marks<cr>", desc = "Search harpoon marks" },
	-- 		{ "ö", '<cmd>lua require("harpoon.mark").add_file()<cr>', desc = "Create new harpoon file mark" },
	-- 		{ "<C-u>", '<cmd>lua require("harpoon.ui").nav_next()<cr>', desc = "Go to next harpoon file mark" },
	-- 		{ "<C-d>", '<cmd>lua require("harpoon.ui").nav_prev()<cr>', desc = "Go to prev harpoon file mark" },
	-- 	},
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	lazy = true,
	-- },

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
		dependencies = {
			"echasnovski/mini.icons",
		},
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

	-- Thoughts
	-- {
	-- 	"weizheheng/nvim-workbench",
	-- 	keys = {
	-- 		{ "<leader>dp", "<Plug>ToggleProjectWorkbench", desc = "Toggle Project Thoughts Pad" },
	-- 		{ "<leader>db", "<Plug>ToggleBranchWorkbench", desc = "Toggle Branch Thoughts Pad" },
	-- 	},
	-- 	config = function()
	-- 		require("workbench")

	-- 		vim.g.workbench_border = "single"
	-- 	end,
	-- 	event = "VeryLazy",
	-- },

	-- Undotree
	{
		"mbbill/undotree",
		keys = {
			{ "<leader>tu", "<Cmd>UndotreeToggle<CR>", desc = "Toggle undo tree window" },
		},
	},

	-- Nerdtree
	{
		"nvim-neo-tree/neo-tree.nvim",
		keys = {
			{
				"<leader>tt",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = require("util").get_root() })
				end,
				desc = "Explorer NeoTree (root dir)",
			},
			{
				"<leader>tT",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
				end,
				desc = "Explorer NeoTree (cwd)",
			},
		},
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		init = function()
			vim.g.neo_tree_remove_legacy_commands = 1
			if vim.fn.argc() == 1 then
				local stat = vim.loop.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
				end
			end
		end,
		opts = {
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = true,
			},
			window = {
				mappings = {
					["<space>"] = "none",
				},
			},
		},
	},

	-- Color picker
	-- {
	-- 	"nvim-colortils/colortils.nvim",
	-- 	cmd = "Colortils",
	-- 	config = true,
	-- 	keys = {
	-- 		{ "<leader>rc", "<Cmd>Colortils picker<cr>", desc = "Pick color" },
	-- 	},
	-- },

	-- Neorg
	-- {
	-- 	"nvim-neorg/neorg",
	-- 	build = ":Neorg sync-parsers",
	-- 	keys = {
	-- 		{ "<leader>tn", "<cmd>Neorg workspace<CR>", desc = "Open Neorg workspace" },
	-- 	},
	-- 	opts = {
	-- 		load = {
	-- 			["core.defaults"] = {}, -- Loads default behaviour
	-- 			["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
	-- 			["core.norg.dirman"] = { -- Manages Neorg workspaces
	-- 				config = {
	-- 					workspaces = {
	-- 						notes = "~/notes",
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 	},

	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- },

	-- GitSigns
	{
		"lewis6991/gitsigns.nvim",
		config = true,
		event = { "BufNewFile", "BufReadPost" },
	},
}
