return {
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = true,
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
	},

	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				gopls = {
					mason = false,
					staticcheck = true,
				},
			},
		},
	},

	{
		"Walcriz/action-lists.nvim",
		opts = {
			lists = {
				code_insert = {
					go = {
						ft = { "go" },
						actions = {
							Comment = "GoCmt",
							["Tag Rm"] = "GoAddTag",
							["Tag Add"] = "GoRmTag",
						},
					},
				},
			},
		},
	},
}
