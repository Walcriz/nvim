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
        if mr.has_package(tool) then
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        else
          vim.notify(("mason: unknown package '%s'"):format(tool), vim.log.levels.WARN)
        end
      end
    end,
  },
}
