return {
  {
    "Exafunction/windsurf.vim",
    keys = {
      { "§", function() return vim.fn['codeium#Accept']() end, expr = true, silent = true, desc = "code", mode = "i" },
    },
    config = function()
      vim.g.codeium_disable_bindings = 1
    end,
    event = "BufEnter",
  },

  {
    "Walcriz/action-lists.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      lists = {
        code_insert = {
          -- Defined elsewhere
          all = {
            actions = {
              document = function()
                require("neogen").generate()
              end,
            },
          },
        },
        build = {
          -- Defined elsewhere
        },
        test = {
          -- Defined elsewhere
        },
      },
    },
    config = true,
    keys = {
      -- { "<M-Insert>", ":OpenActionList code_insert<CR>", desc = "Open code insert action list" },
    },
  },

  {
    "Chaitanyabsprip/fastaction.nvim",
    config = true,
    event = "VeryLazy",
  },

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows")) and "make install_jsregexp" or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      delete_check_events = { "CursorMoved", "CursorMovedI" },
    },
    -- stylua: ignore
    keys = {
      { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },

  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },

    version = "1.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        documentation = { auto_show = true },
        menu = {
          draw = {
            columns = {
              { "label",     "label_description", gap = 1 },
              { "kind_icon", "kind",              gap = 1 },
            },
          },
        },

        ghost_text = { enabled = true },

        trigger = {
          show_on_accept_on_trigger_character = true,
          show_on_x_blocked_trigger_characters = { "'", '"', '(', '{', '[' }
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      keymap = {
        preset = "default",

        ["<C-n>"] = { "select_next" },
        ["<C-p>"] = { "select_prev" },
        ["<C-b>"] = { "scroll_documentation_up" },
        ["<C-f>"] = { "scroll_documentation_down" },
        ["<C-Space>"] = { "show" },
        ["<C-e>"] = { "hide" },

        -- Enter key: confirm current selection (like cmp.confirm)
        ["<CR>"] = {
          "accept",
          "fallback",
        },
      },
    },

    opts_extend = { "sources.default" },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      require("config.autopairs")
    end,
  },

  -- Commentary
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  {
    "tpope/vim-commentary",
    event = "VeryLazy",
  },

  -- Quick actions and refactorings
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "<leader>rk",
        "<Esc><Cmd>lua require('refactoring').select_refactor()<CR>",
        desc = "Select refactoring (refactoring.nvim)",
        mode = "v",
      },
    },
    config = function(_, opts)
      require("refactoring").setup(opts)
    end,
  },

  -- references
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = { delay = 200 },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("ää", "next")
      map("åå", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("ää", "next", buffer)
          map("åå", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "ää", desc = "Next Reference" },
      { "åå", desc = "Prev Reference" },
    },
  },

  -- buffer remove
  {
    "nvim-mini/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
    },
  },

  -- Guess Indent
  {
    "NMAC427/guess-indent.nvim",
    opts = {
      auto_cmd = false,
      override_editorconfig = true,
    },
    config = true,
    event = "VeryLazy",
  },

  -- Bigfile
  {
    "LunarVim/bigfile.nvim",
    opts = {},
    config = function(_, opts)
      require("bigfile").setup(opppts)
    end
  },

  -- Annotations
  {
    "danymat/neogen", config = true,
  }
}
