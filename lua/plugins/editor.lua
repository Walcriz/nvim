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
			{ "<leader>ö", "<cmd>Telescope harpoon marks<cr>", desc = "Search harpoon marks"},
			{ "<leader>nj", "<cmd>lua require(\"harpoon\").add_file()<cr>", desc = "Create new harpoon file mark" },
			{ "<leader>nl", "<cmd>lua require(\"harpoon\").nav_next()<cr>", desc = "Go to next harpoon file mark" },
			{ "<leader>nh", "<cmd>lua require(\"harpoon\").nav_prev()<cr>", desc = "Go to next harpoon file mark" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		lazy = true,
	},

	-- Visual multi (multi cursors)
	{ "mg979/vim-visual-multi" },

	-- Vim surround
	{ "tpope/vim-surround" },

	-- better diagnostics list and others
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		opts = { use_diagnostic_signs = true },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
			{ "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").previous({ skip_groups = true, jump = true })
					else
						vim.cmd.cprev()
					end
				end,
				desc = "Previous trouble/quickfix item",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						vim.cmd.cnext()
					end
				end,
				desc = "Next trouble/quickfix item",
			},
		},
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
				["gz"] = { name = "+surround" },
				["]"] = { name = "+next" },
				["["] = { name = "+prev" },
				["<leader><tab>"] = { name = "+tabs" },
				["<leader>b"] = { name = "+buffer" },
				["<leader>c"] = { name = "+code" },
				["<leader>f"] = { name = "+file/find" },
				["<leader>g"] = { name = "+git" },
				["<leader>gh"] = { name = "+hunks" },
				["<leader>q"] = { name = "+quit/session" },
				["<leader>s"] = { name = "+search" },
				["<leader>u"] = { name = "+ui" },
				["<leader>w"] = { name = "+windows" },
				["<leader>x"] = { name = "+diagnostics/quickfix" },
				["<leader>n"] = { name = "+harpoon" },
				["<leader>r"] = { name = "+quick refactorings" },
			}
			if Util.has("noice.nvim") then
				keymaps["<leader>sn"] = { name = "+noice" }
			end
			wk.register(keymaps)
		end,
	},

	-- Neogit
	{
		"TimUntersberger/neogit",
		keys = {
			{ "<leader>gg", "<cmd>Neogit kind=split<CR>", desc = "Open neogit ui"},
			{ "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Open commit neogit ui"},
		},
		config = function(_, opts)
			require("neogit").setup(opts)
		end,
	}
}
