return {
  {
    "NvChad/nvim-colorizer.lua",
    enabled = not vim.g.walcriz.core.minimal,
    event = "BufReadPre",
    opts = {
      "*",
      "!.vim",
    },
  },
}
