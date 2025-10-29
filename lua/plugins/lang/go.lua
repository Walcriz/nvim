return {
  {
    "ray-x/go.nvim",
    branch = "treesitter-main",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = true,
    ft = { "go", "gomod" },
    build = function() require("go.install").update_all() end
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
              ["Tag Add"] = "GoAddTag",
              ["Tag Rm"] = "GoRmTag",
            },
          },
        },
      },
    },
  },
}
