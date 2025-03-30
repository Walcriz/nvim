return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old and doesn't work on Windows
		build = function ()
			require("nvim-treesitter.install").update()
		end,
		event = { "BufReadPost", "BufNewFile" },

		keys = {
			{ "<c-space>", desc = "Increment selection" },
			{ "<bs>", desc = "Schrink selection", mode = "x" },
		},

		---@type TSConfig
		opts = {
			highlight = { enable = true },
			indent = { enable = true, disable = { "python" } },
			context_commentstring = { enable = true, enable_autocmd = false },
			ensure_installed = {
				"bash",
				"java",
				"c",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"c_sharp",
				"css",
				"scss",
				"html",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
				},
			},
			rainbow = {
				enable = true,

				disable = { "html" },

				-- colors = {
				-- 	"#FFD865",
				-- 	"#AB9DF2",
				-- 	"#67ACB5",
				-- },

				hlgroups = {
					"TSRainbow1",
					"TSRainbow2",
					"TSRainbow3",
				},
			},
		},

		---@param opts TSConfig
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
