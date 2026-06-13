return {
  {
    "LunarVim/bigfile.nvim",
    enabled = not vim.g.walcriz.core.minimal,
    opts = {},
    config = function(_, opts)
      require("bigfile").setup(opts)
    end
  },
}
