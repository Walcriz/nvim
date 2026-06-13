return {
  {
    "nanozuki/tabby.nvim",
    opts = {
      hl = {
        base = "TabLineFill",

        tab = {
          normal = "TabLine",
          active = "TabLineSel",
        },

        win = {
          normal = "TabLine",
          active = "TabLineSel",
        },

        tail = "TabLine",
      },

      icons = {
        tab_active = "",
        tab_inactive = "",
        win_active = "",
        win_inactive = "",
        close = "",
        tail = "  ",
      },

      separator = {
        left = "",
        right = "",
      },
    },

    config = function(_, opts)
      local hl = opts.hl
      local icons = opts.icons
      local sep = opts.separator

      require("tabby.tabline").set(function(line)
        return {
          -- Tabs
          line.tabs().foreach(function(tab)
            local is_current = tab.is_current()
            local tab_hl = is_current and hl.tab.active or hl.tab.normal

            return {
              line.sep(sep.left, tab_hl, hl.base),
              is_current and icons.tab_active or icons.tab_inactive,
              tab.number(),
              tab.name(),
              tab.close_btn(icons.close),
              line.sep(sep.right, tab_hl, hl.base),
              hl = tab_hl,
              margin = " ",
            }
          end),

          line.spacer(),

          -- Windows
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            local is_current = win.is_current()
            local win_hl = is_current and hl.win.active or hl.win.normal

            return {
              line.sep(sep.left, win_hl, hl.base),
              is_current and icons.win_active or icons.win_inactive,
              win.buf_name(),
              line.sep(sep.right, win_hl, hl.base),
              hl = win_hl,
              margin = " ",
            }
          end),

          -- Tail
          {
            line.sep(sep.left, hl.tail, hl.base),
            { icons.tail, hl = hl.tail },
          },

          hl = hl.base,
        }
      end)
    end,

    event = "VeryLazy",
  },
}
