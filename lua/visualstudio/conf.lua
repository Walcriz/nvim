local cfg = {
  core = {
    notify_about_indentation = false,
  },
}

vim.g.walcriz = vim.tbl_deep_extend("force", vim.g.walcriz or {}, cfg)
