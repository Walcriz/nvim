local function lsp_progress_component()
  local ok, lsp_progress = pcall(require, "lsp-progress")
  if ok then
    return lsp_progress.progress
  end

  return function()
    return ""
  end
end

local function indent_lualine()
  return {
    function()
      -- Get indentation settings
      local expandtab = vim.bo.expandtab
      local shiftwidth = vim.bo.shiftwidth
      local tabstop = vim.bo.tabstop

      if expandtab then
        return 'spc ' .. shiftwidth
      else
        return 'tab ' .. tabstop
      end
    end,
  }
end

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { { "linrongbin16/lsp-progress.nvim", optional = true } },
    opts = {
      options = {
        icons_enabled = false,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
        },
        disabled_filetypes = {
          statusline = { "NvimTree" },
          winbar = {},
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "filename" },
        lualine_c = { lsp_progress_component() },
        lualine_x = {
          {
            "diagnostics",
            on_click = function()
              require("dapui").toggle()
            end,
            icons_enabled = true,
          },
          indent_lualine(),
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = {},
    },

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
}
