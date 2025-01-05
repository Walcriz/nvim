return {
  {
    "Exafunction/codeium.vim",
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
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      lists = {
        code_insert = {
          -- Defined elsewhere
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
      { "<M-Insert>", ":OpenActionList code_insert<CR>", desc = "Open code insert action list" },
    },
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
      delete_check_events = {"TextChanged", "TextChangedI"},
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          print(vim.fn["codeium#GetStatusString"]())
          if vim.fn["codeium#GetStatusString"]() ~= "0" then
            return vim.fn["codeium#Accept"]()
          end

          if require("luasnip").expand_or_jumpable() then -- Dont know how to fix
            return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
          end

          return "<tab>"
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
  { -- Possibly use https://github.com/windwp/nvim-autopairs instead
    "echasnovski/mini.pairs",
    lazy = false,
    opts = {
      mappings = {
        ["<"] = { action = "open", pair = "<>", neigh_pattern = "[^ \t].", register = { cr = false } },
        [">"] = { action = "close", pair = "<>", neigh_pattern = "[^ \t].", register = { cr = false } },
        ['"'] = { action = "close" },
        ["'"] = { action = "close" }
      },
    },
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },

  -- Commentary
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  {
    "tpope/vim-commentary",
    event = "VeryLazy",
  },

  ---- better text-objects
  --{
  --  "echasnovski/mini.ai",
  --  -- keys = {
  --  --   { "a", mode = { "x", "o" } },
  --  --   { "i", mode = { "x", "o" } },
  --  -- },
  --  event = "VeryLazy",
  --  dependencies = { "nvim-treesitter-textobjects" },
  --  opts = function()
  --    local ai = require("mini.ai")
  --    return {
  --      n_lines = 500,
  --      custom_textobjects = {
  --        o = ai.gen_spec.treesitter({
  --          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
  --          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
  --        }, {}),
  --        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
  --        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
  --      },
  --    }
  --  end,
  --  config = function(_, opts)
  --    require("mini.ai").setup(opts)
  --    -- register all text objects with which-key
  --    if require("util").has("which-key.nvim") then
  --      ---@type table<string, string|table>
  --      local i = {
  --        [" "] = "Whitespace",
  --        ['"'] = 'Balanced "',
  --        ["'"] = "Balanced '",
  --        ["`"] = "Balanced `",
  --        ["("] = "Balanced (",
  --        [")"] = "Balanced ) including white-space",
  --        [">"] = "Balanced > including white-space",
  --        ["<lt>"] = "Balanced <",
  --        ["]"] = "Balanced ] including white-space",
  --        ["["] = "Balanced [",
  --        ["}"] = "Balanced } including white-space",
  --        ["{"] = "Balanced {",
  --        ["?"] = "User Prompt",
  --        _ = "Underscore",
  --        a = "Argument",
  --        b = "Balanced ), ], }",
  --        c = "Class",
  --        f = "Function",
  --        o = "Block, conditional, loop",
  --        q = "Quote `, \", '",
  --        t = "Tag",
  --      }
  --      local a = vim.deepcopy(i)
  --      for k, v in pairs(a) do
  --        a[k] = v:gsub(" including.*", "")
  --      end

  --      local ic = vim.deepcopy(i)
  --      local ac = vim.deepcopy(a)
  --      for key, name in pairs({ n = "Next", l = "Last" }) do
  --        i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
  --        a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
  --      end
  --      require("which-key").register({
  --        mode = { "o", "x" },
  --        i = i,
  --        a = a,
  --      })
  --    end
  --  end,
  --,}

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

  -- Context at top
  -- {
  -- 	"nvim-treesitter/nvim-treesitter-context",
  -- 	dependencies = { "nvim-treesitter/nvim-treesitter" },
  -- 	opts = {
  -- 		enable = true,
  -- 		max_lines = 3,
  -- 		trim_scope = "inner",
  -- 	},
  -- 	config = function(_, opts)
  -- 		require("treesitter-context").setup(opts)
  -- 		vim.cmd("hi TreesitterContext guibg=NONE ctermbg=NONE")
  -- 	end,
  -- 	event = { "BufReadPost", "BufNewFile" },
  -- },
}
