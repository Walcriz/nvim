return {
  {
    "NeogitOrg/neogit",
    enabled = not vim.g.walcriz.core.minimal and vim.g.walcriz.core.use_git,
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit kind=split<CR>", desc = "Open neogit" },
    },
    opts = {},
    config = function(_, opts)
      require("neogit").setup(opts)
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
  },
}
