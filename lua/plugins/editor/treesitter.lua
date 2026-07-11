return {
  {
    "romus204/tree-sitter-manager.nvim",
    lazy = false,
    config = function()
      local tsm = require("tree-sitter-manager")
      local installer = require("tree-sitter-manager.installer")
      local util = require("tree-sitter-manager.util")
      local cfg = require("tree-sitter-manager.config")
      local filetypes = require("tree-sitter-manager.filetypes")

      tsm.setup({
        auto_install = false,
        highlight = true,
        nohighlight = {},
        ensure_installed = {},
        border = "rounded",
      })

      local function filetype_to_lang(ft)
        local lang = vim.treesitter.language.get_lang(ft)
        if lang and cfg.effective_repos[lang] then
          return lang
        end

        for parser, aliases in pairs(filetypes) do
          if vim.tbl_contains(aliases, ft) then
            return parser
          end
        end

        if cfg.effective_repos[ft] then
          return ft
        end
        return nil
      end

      local installing = {}
      local asked = {}

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local ft = args.match
          if not ft or ft == "" then return end

          local lang = filetype_to_lang(ft)
          if not lang then return end

          local installed = util.is_only_query(lang)
            and vim.uv.fs_stat(util.qpath(lang))
            or vim.uv.fs_stat(util.ppath(lang))
          if installed then return end

          if installing[lang] or asked[lang] then return end
          asked[lang] = true

          vim.defer_fn(function()
            vim.ui.select({ "Yes", "No" }, {
              prompt = "Tree-sitter parser for '" .. lang .. "' not installed. Install now?",
            }, function(choice)
              if choice ~= "Yes" then
                vim.notify("Skipping Tree-sitter installation for " .. lang, vim.log.levels.WARN)
                return
              end

              installing[lang] = true
              local buf = args.buf

              installer.install(lang, function(ok)
                installing[lang] = nil
                if ok then
                  vim.schedule(function()
                    if vim.api.nvim_buf_is_valid(buf) then
                      vim.treesitter.start(buf, lang)
                    end
                  end)
                else
                  vim.notify(
                    "Tree-sitter parser for " .. lang .. " failed to install",
                    vim.log.levels.ERROR
                  )
                end
              end)
            end)
          end, 300)
        end,
      })
    end,
  },
}
