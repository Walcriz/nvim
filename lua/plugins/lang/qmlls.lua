return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				qmlls = {
					mason = false,
					cmd = {"qml-lsp", "-E"},
				},
			},
		},
	}
}
