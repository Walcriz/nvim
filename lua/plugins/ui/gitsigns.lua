return {
  {
    "lewis6991/gitsigns.nvim",
    enabled = vim.g.walcriz.core.use_git,
    config = true,
    event = { "BufNewFile", "BufReadPost" },
  },
}
