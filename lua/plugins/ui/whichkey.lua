return {
  {
    "folke/which-key.nvim",
    enabled = not vim.g.walcriz.core.minimal,

    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      local keymaps = {
        mode = { "n", "v" },
        { "<leader><tab>", group = "tabs" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "code actions" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>gp", group = "preview" },
        { "<leader>n", group = "harpoon" },
        { "<leader>o", group = "server actions" },
        { "<leader>r", group = "quick refactorings" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "tools" },
        { "<leader>u", group = "ui" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
      }
      if require("common").has("noice.nvim") then
        keymaps["<leader>sn"] = { name = "+noice" }
      end
      wk.add(keymaps)
    end,
  },
}
