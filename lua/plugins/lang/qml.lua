return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "jose-elias-alvarez/typescript.nvim" },
    opts = {
      setup = {
        tsserver = function(_, opts)
          require("util").on_attach(function(client)
            if client.name == "qmlls" then
              client.server_capabilities.semanticTokensProvider = nil
            end
          end)
          require("qmlls").setup({ server = opts })
          return true
        end,
      },
    },
  },
}
