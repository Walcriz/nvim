---@diagnostic disable: missing-fields
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    version = false, -- last release is way too old and doesn't work on Windows
    branch = "main",
    build = function ()
      require("nvim-treesitter.install").update()
    end,
    event = { "BufReadPost", "BufNewFile" },

    ---@type TSConfig
    opts = {
      highlight = { enable = true },
      playground = { enable = true },
      indent = { enable = true, disable = { "python" } },
      context_commentstring = { enable = true, enable_autocmd = false },
      rainbow = {
        enable = true,

        disable = { "html" },

        -- colors = {
        -- 	"#FFD865",
        -- 	"#AB9DF2",
        -- 	"#67ACB5",
        -- },

        hlgroups = {
          "TSRainbow1",
          "TSRainbow2",
          "TSRainbow3",
        },
      },
    },

    config = function(_, opts)
      require("nvim-treesitter").setup(opts)

      local treesitter = require("nvim-treesitter")

      local installing_cache = {}
      local asked_cache = {}

      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(args)
          local buf = args.buf
          local lang = vim.bo[buf].filetype

          if not lang or lang == "" then
            -- use file extension
            lang = vim.fn.fnamemodify(vim.fn.expand("%"), ":e")
          end

          -- Skip if no filetype
          if not lang or lang == "" then return end

          if lang == "cs" then
            lang = "c_sharp"
          elseif lang == "javascriptreact" then
            lang = "jsx"
          elseif lang == "typescriptreact" then
            lang = "tsx"
          end

          -- Skip if Treesitter has no config for this filetype
          if not require("nvim-treesitter.parsers")[lang] then return end

          local installed = treesitter.get_installed('parsers')

          -- If parser is installed, start Tree-sitter
          if vim.tbl_contains(installed, lang) then
            vim.treesitter.start(buf, lang)
            return
          end

          vim.defer_fn(function()
            if installing_cache[lang] then
              return
            end

            if asked_cache[lang] then
              return
            end

            -- Floating prompt
            vim.ui.select({ "Yes", "No" }, {
              prompt = "Tree-sitter parser for '" .. lang .. "' is not installed. Install now?",
            }, function(choice)
              asked_cache[lang] = true

              if choice == "Yes" then
                installing_cache[lang] = true
                local async = require("nvim-treesitter.async")
                async.async(function()
                  vim.notify("Installing Tree-sitter parser for " .. lang .. "...", vim.log.levels.INFO)
                  async.arun(function()
                    return async.await(require("nvim-treesitter.install").install, lang)
                  end):wait()
                  vim.notify("Tree-sitter parser for " .. lang .. " installed", vim.log.levels.INFO)
                  vim.defer_fn(function()
                    vim.treesitter.start(buf, lang)
                  end, 10)
                end)()
                -- Optionally start after install
              else
                vim.notify("Skipping Tree-sitter installation for " .. lang, vim.log.levels.WARN)
              end
            end)
          end, 300)
        end,
      })
    end,
  },
}
