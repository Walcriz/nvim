return {
  {
    "ray-x/lsp_signature.nvim",
    enabled = vim.g.walcriz.core.lsp,

    opts = {
      bind = true,
      noice = true,

      floating_window = false,

      hint_prefix = "",
      -- stylua: ignore
      hint_inline = function() return false end,

      always_trigger = true,
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
}
