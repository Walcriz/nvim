return {
  {
    "nvim-mini/mini.files",
    lazy = false,
    keys = {
      {
        "fn",
        function()
          MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        end,
        desc = "File browser (Current Buffer Dir)",
      },
      {
        "FN",
        function()
          MiniFiles.open()
        end,
        desc = "File browser",
      },
    },
    opts = {
      options = {
        permanent_delete = false,
        use_as_default_explorer = true,
        close_on_open = true,
      },
      mappings = {
        go_in_plus = "<enter>",
        go_out = "<C-o>",
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event)
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end,
      })

      -- Create an autocommand that triggers on window leave
      vim.api.nvim_create_autocmd("WinLeave", {
        callback = function()
          -- Get the filetype of the current buffer (the one being left)
          local current_ft = vim.bo.filetype

          -- Get the window ID of the window being entered
          local new_win = vim.api.nvim_get_current_win()
          local new_buf = vim.api.nvim_win_get_buf(new_win)
          local new_ft = vim.bo[new_buf].filetype

          -- If the current window is 'mini-files' and the new window is not, close mini.files
          if current_ft == "minifiles" and new_ft ~= "minifiles" then
            require("mini.files").close()
          end
        end,
        desc = "Close mini.files when switching to a non-mini.files window",
      })
    end,
  },
}
