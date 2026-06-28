return {
  {
    "goolord/alpha-nvim",
    enabled = not vim.g.walcriz.core.minimal and vim.g.walcriz.core.dashboard,
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠲⠶⣶⣶⣤⣄⣀⠀⠀⠀⠀⠀⠀
        ⠀⠀⠀⠀⠀⣤⣄⠀⠀⠀⠀⠀⠀⠈⠙⢿⣿⣷⣦⡀⠀⠀⠀
        ⠀⠀⠀⠀⠀⢹⣿⣿⣦⣀⣀⣀⣠⣤⣤⣤⡽⢿⣿⣿⣦⡀⠀
        ⠀⠀⠀⠀⠀⢀⣿⣿⠿⠿⣿⣿⣿⣿⣿⡿⠀⠈⣿⣿⣿⣷⡀     ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
        ⠀⠀⠀⠀⠀⠸⢱⢹⣷⠞⢛⣿⣿⣿⡿⠁⠀⠀⢹⣿⣿⣿⣧     ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
        ⠀⠀⠀⠀⠀⢿⣾⣿⣇⡀⠧⢬⣿⣿⠁⠀⠀⠀⢸⣿⣿⣿⣿     ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
        ⡄⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⣿⣿⣿⣿⣿     ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
        ⢻⣄⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣦⡀⠀⠀⣼⣿⣿⣿⣿⡟     ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
        ⠈⢿⣦⣀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⡿⠁     ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
        ⠀⠈⠻⣿⣷⣶⣤⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀
        ⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⠀
        ⠀⠀⠀⠀⠀⠀⠉⠙⠛⠿⠿⠿⠿⠿⠛⠋
        ]]

      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("ff", " " .. " Find file", ":Telescope find_files<CR>"),
        dashboard.button("fn", " " .. " File browser", "<cmd>lua MiniFiles.open()<CR>"),
        dashboard.button("fr", " " .. " Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("fg", "󰮗 " .. " Find text", ":Telescope live_grep disable_devicons=true<CR>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>:cd %:h<CR>"),
        dashboard.button("p", " " .. " Restore Session", [[:lua require("persistence").select() <cr>]]),
        dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
        dashboard.button("m", "󰢛 " .. " Mason", ":Mason<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.bo.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted", -- Comes from that this is a fork
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  {
    "dstein64/vim-startuptime",
    enabled = not vim.g.walcriz.core.minimal and vim.g.walcriz.core.dashboard,
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
}
