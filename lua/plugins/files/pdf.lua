return {
  {
    "r-pletnev/pdfreader.nvim",
    enabled = not vim.g.walcriz.core.minimal and vim.g.walcriz.env.using_kitty,
    lazy = false,
    dependencies = {
      "folke/snacks.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("pdfreader").setup()
    end,
  },
}
