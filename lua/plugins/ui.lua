return {
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Delete all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      background_colour = "#000000",
    },
    init = function()
      vim.opt.termguicolors = true
      vim.notify = require("notify")
    end,
  },

  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = true,
    opts = {
      select = {
        telescope = {
          sorting_strategy = "ascending",
          results_title = false,
          layout_strategy = "center",
          borderchars = {
            results = { " " },
            prompt = { "▄", "▌", "▀", "▐", "▗", "▖", "▘", "▝" },
          },
          layout_config = {
            width = 0.35,
            height = 0.35,
          },
        },
      },
      input = {
        border = "none",
        max_width = { 140, 0.9 },
        min_width = { 20, 0.1 },
        win_options = {
          listchars = "precedes:<,extends:>",
          sidescrolloff = 2,
        },
      },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  {
    "linrongbin16/lsp-progress.nvim",
    config = true
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "linrongbin16/lsp-progress.nvim" },
    opts = function()
      return {
        options = {
          icons_enabled = false,
          theme = 'onedark',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
          }
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'filename' },
          lualine_c = { require("lsp-progress").progress },
          lualine_x = { { 'diagnostics', on_click = function() require("dapui").toggle() end, icons_enabled = true },
             require("util").get_indent_lualine(), 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        extensions = {}
      }
    end,
    config = function(_, opts)
      require("lualine").setup(opts)
      vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = "lualine_augroup",
        pattern = "LspProgressStatusUpdated",
        callback = require("lualine").refresh,
      })
    end,
    event = "VeryLazy"
  },

  -- statusline
  -- {
  --   "itchyny/lightline.vim",
  --   config = function()
  --     vim.g.lightline = {
  --       colorscheme = "one",
  --       enable = {
  --         tabline = false,
  --       },
  --       active = {
  --         left = {
  --           { "mode",     "paste" },
  --           { "readonly", "filename" },
  --           { "lsp_info", "lsp_hints", "lsp_errors", "lsp_warnings", "lsp_ok", "lsp_status" },
  --         },
  --       },
  --     }
  --   end,
  --   lazy = false,
  --   -- dependencies = { "josa42/nvim-lightline-lsp" },
  -- },

  -- {
  --   "josa42/nvim-lightline-lsp",
  --   config = function()
  --     vim.cmd("call lightline#lsp#register()")
  --   end,
  --   dependencies = {
  --     "itchyny/lightline.vim"
  --   }
  -- },

  -- Dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠲⠶⣶⣶⣤⣄⣀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣤⣄⠀⠀⠀⠀⠀⠀⠈⠙⢿⣿⣷⣦⡀⠀⠀⠀
⠀⠀⠀⠀⠀⢹⣿⣿⣦⣀⣀⣀⣠⣤⣤⣤⡽⢿⣿⣿⣦⡀⠀
⠀⠀⠀⠀⠀⢀⣿⣿⠿⠿⣿⣿⣿⣿⣿⡿⠀⠈⣿⣿⣿⣷⡀     ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
⠀⠀⠀⠀⠀⠸⢱⢹⣷⠞⢛⣿⣿⣿⡿⠁⠀⠀⢹⣿⣿⣿⣧     ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
⠀⠀⠀⠀⠀⢿⣾⣿⣇⡀⠧⢬⣿⣿⠁⠀⠀⠀⢸⣿⣿⣿⣿     ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
⡄⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⣿⣿⣿⣿⣿     ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
⢻⣄⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣦⡀⠀⠀⣼⣿⣿⣿⣿⡟     ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
⠈⢿⣦⣀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⡿⠁     ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
⠀⠈⠻⣿⣷⣶⣤⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀
⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠉⠙⠛⠿⠿⠿⠿⠿⠛⠋
			]]

      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("ff", " " .. " Find file", ":Telescope find_files<CR>"),
        dashboard.button("fn", " " .. " File browser", "<cmd>Oil<CR>"),
        dashboard.button("fp", " " .. " Open project", ":Telescope project<CR>"),
        dashboard.button("fr", " " .. " Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("fg", "󰮗 " .. " Find text", ":Telescope live_grep disable_devicons=true<CR>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>:cd %:h<CR>"),
        dashboard.button(
          "s",
          " " .. " Restore Session",
          [[:lua require("persistence").load({ last = true }) <cr>]]
        ),
        dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
        dashboard.button("m", "󰢛 " .. " Mason", ":Mason<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted", -- Comes from that this is a fork
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
    dependencies = {
      "stevearc/oil.nvim",
    }
  },

  -- icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      color_icons = false,
    },
    config = true,
  },

  -- ui components
  -- {
  --   "MunifTanjim/nui.nvim",
  --   lazy = true,
  -- },

  -- Rainbow brackets/delimiters
  {
    "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    event = "VimEnter",
    opts = {
      highlight = {
        'TSRainbow1',
        'TSRainbow2',
        'TSRainbow3',
      },
    },
    config = function(_, opts)
      require("rainbow-delimiters.setup").setup(opts)
    end,
  },

  -- Colorize colors
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   event = "VeryLazy",
  -- },

  -- DAP Ui
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      { "<leader>dU", [[<cmd>lua require("dapui").toggle()<cr>]], desc = "Toggle UI" },
      { "<leader>de", [[<cmd>lua require("dapui").eval()<cr>]],   desc = "Eval Code" },
      { "<leader>de", [[<cmd>lua require("dapui").eval()<cr>]],   desc = "Eval Code", mode = "v" },
    },
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    lazy = true,
  },

  -- DAP virutal text (very nice)
  {
    "theHamsta/nvim-dap-virtual-text",
    ft = { "go", "gomod" },
  },

  {
    "ray-x/lsp_signature.nvim",
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

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    config = function()
      require("ibl").setup({
        -- for example, context is off by default, use this to turn it on
        -- show_current_context = false,
        -- show_current_context_start = false,

        whitespace = {
          remove_blankline_trail = true,
          highlight = "IndentBlankline",
        },

        indent = {
          smart_indent_cap = true,
        },

        scope = {
          enabled = false,
        },
      })
    end,
  },

  {
    "nanozuki/tabby.nvim",
    opts = {
      theme = {
        fill = "TabLineFill",
        -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
        head = "TabLine",
        current_tab = "TabLineSel",
        tab = "TabLine",
        win = "TabLine",
        tail = "TabLine",
      },
    },
    config = function(_, opts)
      local theme = opts.theme
      require("tabby.tabline").set(function(line)
        return {
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep("", hl, theme.fill),
              tab.is_current() and "" or "",
              tab.number(),
              tab.name(),
              tab.close_btn(""),
              line.sep("", hl, theme.fill),
              hl = hl,
              margin = " ",
            }
          end),
          line.spacer(),
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            return {
              line.sep("", theme.win, theme.fill),
              win.is_current() and "" or "",
              win.buf_name(),
              line.sep("", theme.win, theme.fill),
              hl = theme.win,
              margin = " ",
            }
          end),
          {
            line.sep("", theme.tail, theme.fill),
            { "  ", hl = theme.tail },
          },
          hl = theme.fill,
        }
      end)
    end,
    event = "VeryLazy",
  },

  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
      tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
    },
    cond = function()
      return vim.fn.has 'win32' ~= 1
    end,
    dependencies = {
      'leafo/magick',
    },
  },
}
