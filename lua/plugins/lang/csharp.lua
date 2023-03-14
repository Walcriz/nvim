return {
	{
		"Hoffs/omnisharp-extended-lsp.nvim",
		ft = "cs",
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = { "Hoffs/omnisharp-extended-lsp.nvim" },
		opts = {
			servers = {
				omnisharp = {
					mason = false,
					enable_import_completion = false,
					organize_imports_on_format = true,
				},
			},

			setup = {
				omnisharp = function(_, opts)
					require("util").on_attach(function(client, buffer)
						if client.name == "omnisharp" or client.name == "omnisharp_mono" then
							vim.keymap.set(
								"n",
								"gd",
								"<cmd>lua require('omnisharp_extended').lsp_definitions()<cr>",
								{ noremap = false, buffer = buffer, desc = "Goto definition" }
							)
						end
					end)
				end,
			},
		},
	},
}
