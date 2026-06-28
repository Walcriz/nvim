return {
  {
    "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
    enabled = vim.g.walcriz.core.use_treesitter and not vim.g.walcriz.core.minimal,
    event = "VimEnter",
    opts = {
      highlight = {
        "TSRainbow1",
        "TSRainbow2",
        "TSRainbow3",
      },
    },
    config = function(_, opts)
      require("rainbow-delimiters.setup").setup(opts)
    end,
  },
}
