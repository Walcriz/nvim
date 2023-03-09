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
	{
		"ThePrimeagen/harpoon",
		keys = {
			{ "<leader>ö", "<cmd>Telescope harpoon marks<cr>", desc = "Search harpoon marks" },
			{ "<leader>nj", '<cmd>lua require("harpoon").add_file()<cr>', desc = "Create new harpoon file mark" },
			{ "<leader>nl", '<cmd>lua require("harpoon").nav_next()<cr>', desc = "Go to next harpoon file mark" },
			{ "<leader>nh", '<cmd>lua require("harpoon").nav_prev()<cr>', desc = "Go to next harpoon file mark" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		lazy = true,
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
				["g"] = { name = "+goto" },
				["]"] = { name = "+next" },
				["["] = { name = "+prev" },
				["<leader><tab>"] = { name = "+tabs" },
				["<leader>b"] = { name = "+buffer" },
				["<leader>c"] = { name = "+code" },
				["<leader>f"] = { name = "+file/find" },
				["<leader>gh"] = { name = "+hunks" },
				["<leader>q"] = { name = "+quit/session" },
				["<leader>s"] = { name = "+search" },
				["<leader>u"] = { name = "+ui" },
				["<leader>w"] = { name = "+windows" },
				["<leader>x"] = { name = "+diagnostics/quickfix" },
				["<leader>n"] = { name = "+harpoon" },
				["<leader>r"] = { name = "+quick refactorings" },
				["<leader>o"] = { name = "+server actions" },
				["<leader>t"] = { name = "+tools" },
				["<leader>d"] = { name = "+code actions" },
				["<leader>gp"] = { name = "+preview" },
			}
			if Util.has("noice.nvim") then
				keymaps["<leader>sn"] = { name = "+noice" }
			end
			wk.register(keymaps)
		end,
	},

	-- Scratch buffer
	{
		"n-shift/scratch.nvim",
		keys = {
			{
				"<leader>x",
				"<Cmd>sp<CR><Cmd>ScratchNew lua<CR><C-w>-<C-w>-<C-w>-<C-w>-<C-w>-<C-w>-<C-w>-<C-w>-",
				desc = "Open a new scratch buffer",
			},
		},
		event = "VeryLazy",
	},

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
	{
		"nvim-colortils/colortils.nvim",
		cmd = "Colortils",
		config = true,
		keys = {
			{ "<leader>rc", "<Cmd>Colortils picker<cr>", desc = "Pick color" },
		},
	},
}
