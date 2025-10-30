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
          settings = {
            FormattingOptions = {
              OrganizeImports = true,
            },
          }
          -- These were changed in lsp config here: https://github.com/neovim/nvim-lspconfig/commit/2054452352d69fa1c38696434163ede26e48d5b8
          -- enable_import_completion = false,
          -- organize_imports_on_format = true,
        },
      },

      setup = {
        omnisharp = function(_, opts)
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
      },
    },
  },
}
