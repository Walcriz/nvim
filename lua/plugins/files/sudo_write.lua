return {
  {
    dir = vim.fn.stdpath("config") .. "/plugin/sudo_write",
    name = "sudo_write",
    enabled = vim.g.walcriz.core.allow_sudo_write,
    lazy = false,

    config = function()
      vim.api.nvim_create_user_command("W", require("sudo_write").save_with_sudo, {})
      vim.cmd([[
      cnoreabbrev <expr> w getcmdtype() == ':' && getcmdline() ==# 'w' ? 'W' : 'w'
      ]])
    end,
  }
}
