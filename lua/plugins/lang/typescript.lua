return {

	-- correctly setup lspconfig
	{
		"neovim/nvim-lspconfig",
		dependencies = { "jose-elias-alvarez/typescript.nvim" },
		opts = {
			-- make sure mason installs the server
			servers = {
				--ts_ls = {
				--	---@type lspconfig.options.ts_ls
				--	settings = {
				--		completions = {
				--			completeFunctionCalls = true,
				--		},
				--	},
				--},
			},
			setup = {
				tsserver = function(_, opts)
					require("util").on_attach(function(client, buffer)
						if client.name == "tsserver" then
              -- stylua: ignore
              vim.keymap.set("n", "<leader>ro", "<cmd>TypescriptOrganizeImports<CR>", { buffer = buffer, desc = "Organize Imports" })
              -- stylua: ignore
              vim.keymap.set("n", "<leader>rR", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = buffer })
						end
					end)
					require("typescript").setup({ server = opts })
					return true
				end,
			},
		},
	},
}
