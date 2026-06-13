return {
  {
    "nvim-tree/nvim-tree.lua",
    enabled = not vim.g.walcriz.core.minimal,

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    keys = {
      {
        "<leader>tt",
        function()
          require("nvim-tree.api").tree.open()
        end,
        desc = "File browser",
      },
    },

    opts = {
      reload_on_bufenter = true,
      filters = {
        custom = { "^.git$" },
      },
      actions = {
        open_file = {
          resize_window = false, -- don't resize window when opening file
        },
      },
      update_focused_file = {
        enable = true,
        update_root = true,
      },
    },

    config = function(_, opts)
      require("nvim-tree").setup(opts)

      vim.api.nvim_create_autocmd("QuitPre", {
        callback = function()
          local invalid_win = {}
          local wins = vim.api.nvim_list_wins()
          for _, w in ipairs(wins) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
            if bufname:match("NvimTree_") ~= nil then
              table.insert(invalid_win, w)
            end
          end
          if #invalid_win == #wins - 1 then
            -- Should quit, so we close all invalid windows.
            for _, w in ipairs(invalid_win) do
              vim.api.nvim_win_close(w, true)
            end
          end
        end,
      })

      local api = require("nvim-tree.api")

      vim.keymap.set("n", "<leader>e", function()
        api.tree.find_file({ open = true, focus = true })
      end)

      api.events.subscribe(api.events.Event.FileCreated, function(file)
        vim.cmd("edit " .. file.fname)
      end)
    end,
  },
}
