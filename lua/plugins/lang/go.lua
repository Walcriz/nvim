return {
  lsp = "gopls",

  settings = {
    gopls = {
      buildFlags = nil,
    },
  },

  dependencies = {
    {
      "ray-x/go.nvim",
      version = false,
      branch = "master",
      dependencies = {
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
      },
      config = true,
      ft = { "go", "gomod" },
      build = function()
        require("go.install").update_all()
      end,
    },

    {
      "theHamsta/nvim-dap-virtual-text",
      enabled = not vim.g.walcriz.core.minimal,
      ft = { "go", "gomod" },
    },
  },
}
