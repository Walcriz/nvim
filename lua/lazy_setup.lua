local safe = require("common").safe_require

local spec = {}

if vim.g.vscode then
  spec[#spec + 1] = { import = "visualstudio.plugins" }
else
  spec[#spec + 1] = { import = "plugins" }
  spec[#spec + 1] = { import = "plugins.lsp" }
  spec[#spec + 1] = { import = "plugins.editor" }
  spec[#spec + 1] = { import = "plugins.files" }
  spec[#spec + 1] = { import = "plugins.ui" }
end

-- _local always gets the last word, in both modes
local local_plugins = safe("_local.plugins")
if local_plugins then
  spec[#spec + 1] = { "_local.plugins" }
end

-- Setup
require("lazy").setup({
  spec = spec,
  defaults = {
    lazy = true,
    version = false,
  },
  install = { colorscheme = { vim.g.walcriz.appearance and vim.g.walcriz.appearance.colorscheme or "shine" } },
  checker = {
    enabled = true,
    concurrency = 1,
    notify = false,
  }, -- Auto check for plugin updates
  change_detection = {
    enabled = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
