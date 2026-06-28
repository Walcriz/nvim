return {
  {
    "NvChad/nvim-colorizer.lua",
    enabled = not vim.g.walcriz.core.minimal and not vim.g.walcriz.core.color_picker,
    event = "BufReadPre",
    opts = {
      "*",
      "!.vim",
    },
  },
}
