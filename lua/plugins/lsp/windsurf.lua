return {
  {
    "Exafunction/windsurf.vim",
    enabled = vim.g.walcriz.core.lsp and not vim.g.walcriz.core.minimal and vim.g.walcriz.core.use_ai_completion,
    keys = {
      { "§", function() return vim.fn['codeium#Accept']() end, expr = true, silent = true, desc = "code", mode = "i" },
    },
    config = function()
      vim.g.codeium_disable_bindings = 1
    end,
    event = "BufEnter",
  },
}
