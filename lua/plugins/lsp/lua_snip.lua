return {
  {
    "L3MON4D3/LuaSnip",
    enabled = vim.g.walcriz.core.lsp and not vim.g.walcriz.core.minimal,
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
}
