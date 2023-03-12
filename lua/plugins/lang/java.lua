return {
	-- Disable built in lsp
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			if type(opts.disabled_filetypes) == "table" then
				vim.list_extend(opts.disabled_filetypes, { "java", "xml" })
			end
		end,
	},
}
