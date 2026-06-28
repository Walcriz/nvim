local M = {}

function M.lualine()
  local p = require("monokai_legacy").palette
  return {
    normal = {
      a = { fg = p.black, bg = p.green, gui = "bold" },
      b = { fg = p.darkened, bg = p.base4 },
      c = { fg = p.darkened, bg = p.base3 },
      x = { fg = p.darkened, bg = p.base3 },
    },

    insert = {
      a = { fg = p.black, bg = p.blue or p.aqua, gui = "bold" },
    },

    visual = {
      a = { fg = p.black, bg = p.purple, gui = "bold" },
    },

    replace = {
      a = { fg = p.black, bg = p.red, gui = "bold" },
    },

    command = {
      a = { fg = p.black, bg = p.yellow, gui = "bold" },
    },

    inactive = {
      a = { fg = p.grey, bg = p.base3 },
      b = { fg = p.grey, bg = p.base3 },
    },
  }
end

return {
  {
    dir = vim.fn.stdpath("config") .. "/plugin/monokai_legacy",
    name = "monokai_legacy",
    lazy = false,
    priority = 1000,
    config = function()
      require("monokai_legacy").setup()
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = M.lualine,
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        entry_prefix = "  ",
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = { "▄", "▌", "▀", "▐", "▗", "▖", "▘", "▝" },
        set_env = { ["COLORTERM"] = "truecolor" },
      },
    },
  },
}
