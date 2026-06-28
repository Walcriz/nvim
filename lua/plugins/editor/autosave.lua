return {
  {
    "okuuva/auto-save.nvim",
    version = "^1.0.0",
    event = "VeryLazy",
    opts = {
      enabled = true,
      debounce_delay = 1000,
      condition = function(buf)
        -- Only save if buffer is modified and is not a git commit and is not read only
        return vim.api.nvim_get_option_value("modified", { buf = buf })
          and not vim.api.nvim_get_option_value("readonly", { buf = buf })
          and vim.api.nvim_get_option_value("filetype", { buf = buf }) ~= "gitcommit"
      end,
      write_all_buffers = false,
      noautocmd = true,
    },
  },
}
