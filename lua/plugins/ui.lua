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
      vim.notify = vim.schedule_wrap(require("notify"))
    end,
  },

  -- better vim.ui
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    --- @type snacks.Config
    opts = {
      bigfile = { enabled = false },
      indent = {
        enabled = true,
        char = "▎",
        animate = { enabled = false },
        scope = { enabled = false },
      },
      input = { enabled = true },
      picker = {
        enabled = true,
        ui_select = false,
        win = {
          input = {
            keys = {
              ["<C-BS>"] = { "<c-s-w>", mode = { "i" }, expr = true },
            },
          },
        },
        matcher = {
          history_bonus = true,
        },
      },
      quickfile = { enabled = true },
      styles = {
        input = {
          border = "rounded",
          relative = "cursor",
          row = -3,
          col = 0,
          width = 40,
          keys = {
            ["<C-BS>"] = { "<c-s-w>", mode = { "i" }, expr = true },
          },
        },
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      -- Queue for pending selections
      local select_queue = {}
      local select_in_progress = false

      -- Wrapper function to process the queue
      local function process_queue()
        if select_in_progress then
          return
        end

        local next_call = table.remove(select_queue, 1)
        if not next_call then
          return
        end

        local items, opts, on_choice = unpack(next_call)

        -- Check for optional buffer restriction
        if opts and opts.buf then
          local current_buf = vim.api.nvim_get_current_buf()
          if current_buf ~= opts.buf then
            -- If current buffer doesn't match, put it back at the end of the queue and try later
            table.insert(select_queue, next_call)
            -- Retry after a short delay
            vim.defer_fn(process_queue, 50)
            return
          end
        end

        select_in_progress = true

        local delay = (opts and opts.delay) or 0
        if opts and opts.prompt and opts.prompt:find("skeleton") then
          delay = 100
        end

        local function pick()
          Snacks.picker.select(items, opts, function(item, idx)
            select_in_progress = false
            if on_choice then
              on_choice(item, idx)
            end
            -- Process the next item in the queue
            process_queue()
          end)
        end

        if delay > 0 then
          vim.defer_fn(pick, delay)
        else
          pick()
        end
      end

      -- Override vim.ui.select
      vim.ui.select = function(items, opts, on_choice)
        table.insert(select_queue, { items, opts, on_choice })
        process_queue()
      end
    end,
  },

  {
    "linrongbin16/lsp-progress.nvim",
    config = true,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "linrongbin16/lsp-progress.nvim" },
    opts = function()
      return {
        options = {
          icons_enabled = false,
          theme = "onedark",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "filename" },
          lualine_c = { require("lsp-progress").progress },
          lualine_x = {
            {
              "diagnostics",
              on_click = function()
                require("dapui").toggle()
              end,
              icons_enabled = true,
            },
            require("util").get_indent_lualine(),
            "fileformat",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = {},
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
    event = "VeryLazy",
  },

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
        dashboard.button("fr", " " .. " Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("fg", "󰮗 " .. " Find text", ":Telescope live_grep disable_devicons=true<CR>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>:cd %:h<CR>"),
        dashboard.button("p", " " .. " Restore Session", [[:lua require("persistence").select() <cr>]]),
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
    },
  },

  -- icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = true,
  },

  -- ui components
  -- {
  --   "MunifTanjim/nui.nvim",
  --   lazy = true,
  -- },

  -- Rainbow brackets/delimiters
  {
    "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
    event = "VimEnter",
    opts = {
      highlight = {
        "TSRainbow1",
        "TSRainbow2",
        "TSRainbow3",
      },
    },
    config = function(_, opts)
      require("rainbow-delimiters.setup").setup(opts)
    end,
  },

  -- Colorize colors
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      "*",
      "!.vim",
    },
  },

  -- DAP Ui
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      { "<leader>dD", [[<cmd>lua require("dapui").toggle()<cr>]], desc = "Toggle DAP UI" },
      { "<leader>de", [[<cmd>lua require("dapui").eval()<cr>]], desc = "Eval Code" },
      { "<leader>de", [[<cmd>lua require("dapui").eval()<cr>]], desc = "Eval Code", mode = "v" },
    },
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    cmd = { "Debug" },
    config = function(_, opts)
      require("dapui").setup(opts)
      vim.api.nvim_create_user_command("Debug", function()
        require("dapui").toggle()
      end, {})
    end,
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

  -- Scrollbar
  {
    "dstein64/nvim-scrollview",
    event = "VeryLazy",
  },

  {
    "3rd/image.nvim",
    opts = {
      processor = "magick_cli",
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
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
      return vim.fn.has("win32") ~= 1 and vim.fn.has("gui_running") ~= 1
    end,
    dependencies = {
      "leafo/magick",
    },
    build = false,
  },

  {
    "r-pletnev/pdfreader.nvim",
    lazy = false,
    dependencies = {
      "folke/snacks.nvim", -- image rendering
      "nvim-telescope/telescope.nvim", -- pickers
    },
    config = function()
      require("pdfreader").setup()
    end,
  },
}
