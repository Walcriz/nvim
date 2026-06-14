return {
  {
    "LunarVim/bigfile.nvim",
    enabled = not vim.g.walcriz.core.minimal,
    event = "BufReadPre",
    opts = {},
    config = function(_, opts)
      require("bigfile").setup(opts)
    end
  },
}
