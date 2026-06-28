return {
  lsp = "texlab",

  dependencies = {
    {
      "lervag/vimtex",
      ft = { "tex" },

      init = function()
        vim.g.vimtex_view_method = "zathura"
      end,
    },
  },
}
