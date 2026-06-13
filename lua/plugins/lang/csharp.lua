return {
  lsp = "omnisharp",

  settings = {
    omnisharp = {
      FormattingOptions = {
        OrganizeImports = true,
      },
    }
  },

  setup = function()
    require("util").on_attach(function(client, buffer)
      if client.name == "omnisharp" or client.name == "omnisharp_mono" then
        client.server_capabilities.semanticTokensProvider = nil

        vim.keymap.set(
          "n",
          "gd",
          "<cmd>lua require('omnisharp_extended').lsp_definitions()<cr>",
          { noremap = false, buffer = buffer, desc = "Goto definition" }
        )
      end
    end)
  end,

  dependencies = {
    "Hoffs/omnisharp-extended-lsp.nvim"
  }
}
