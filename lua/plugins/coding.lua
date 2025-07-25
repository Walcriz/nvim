return {
  {
    "Exafunction/windsurf.vim",
    keys = {
      -- { "<Tab>", "<Cmd>call codeium#Accept()<CR>", desc = "code", mode = "i" }
    },
    config = function ()
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
              document = function ()
                require("neogen").generate()
              end
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
      delete_check_events = {"CursorMoved", "CursorMovedI"},
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          local status = vim.fn["codeium#GetStatusString"]()
          if status ~= "0" and status ~= "*" then
            return vim.fn["codeium#Accept"]()
          end

          local luasnip = require("luasnip")
          if luasnip.locally_jumpable(1) then
            luasnip.jump(1)
            return ""
          else
            return "<tab>"
          end
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },
  -- CMP
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      local cmp = require("cmp")
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          {
            name = "luasnip",
            entry_filter = function (_, ctx)
              return not vim.tbl_contains(require("config").snippet_ignore_filetypes, ctx.filetype)
            end
          },
          { name = "buffer" },
          { name = "path" },
          { name = "codeium" }
        }),
        formatting = {
          format = function(_, item)
            local icons = require("config").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
      }
    end,
  },

  -- auto pairs
  -- { -- Possibly use https://github.com/windwp/nvim-autopairs instead
  --   "echasnovski/mini.pairs",
  --   lazy = false,
  --   opts = {
  --     mappings = {
  --       ["<"] = { action = "open", pair = "<>", neigh_pattern = "[^ \t].", register = { cr = false } },
  --       [">"] = { action = "close", pair = "<>", neigh_pattern = "[^ \t].", register = { cr = false } },
  --       ['"'] = { action = "close" },
  --       ["'"] = { action = "close" }
  --     },
  --   },
  --   config = function(_, opts)
  --     require("mini.pairs").setup(opts)
  --   end,
  -- },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      require("config.autopairs")
    end
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
    "echasnovski/mini.bufremove",
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
      require("bigfile").setup(opts)
    end
  },

  -- Annotations
  {
    "danymat/neogen",
    config = true,
  }
}
