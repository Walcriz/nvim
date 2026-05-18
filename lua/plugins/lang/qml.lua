return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        qmlls = function(_, _)
          require("util").on_attach(function(client)
            if client and client.name == "qmlls" then
              client.server_capabilities.semanticTokensProvider = nil
              vim.lsp.semantic_tokens.enable(false, { client_id = client.id })
            end
          end)
          return false
        end,
      },
    },
  },
}
