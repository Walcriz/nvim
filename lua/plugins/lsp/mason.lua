return {
  {
    "williamboman/mason.nvim",
    enabled = vim.g.walcriz.core.lsp,

    cmd = "Mason",
    keys = {
      { "<leader>dm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = {
      ensure_installed = {},
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      require("plugins.lang._lazyload").setup(require("plugins.lang._loader").load().langs)
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },
}
