return {
  {
    "tpope/vim-commentary",
    event = "VeryLazy",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    enabled = vim.g.walcriz.core.use_treesitter,
  },
}
