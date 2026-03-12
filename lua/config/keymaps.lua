local Util = require("util")
local map = Util.map

-- map("i", "<C-H>", "<C-W>", { desc = "" })
map("i", "<C-BS>", "<C-W>", { noremap = true, silent = true })

-- Go back to previous file
map("i", "<C-b>", "<C-6>", { desc = "Jump back to previous file" })
map("n", "<C-b>", "<C-6>", { desc = "Jump back to previous file" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- lazy
map("n", "<leader>dp", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- floating terminal
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

-- tabs
map("n", "<Space>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<Space>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<Space><Space>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<Space>k", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<Space>q", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<Space>j", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

map("n", "<Space>1", "<cmd>tabn 1<cr>", { desc = "Goto tab 1" })
map("n", "<Space>2", "<cmd>tabn 2<cr>", { desc = "Goto tab 2" })
map("n", "<Space>3", "<cmd>tabn 3<cr>", { desc = "Goto tab 3" })
map("n", "<Space>4", "<cmd>tabn 4<cr>", { desc = "Goto tab 4" })
map("n", "<Space>5", "<cmd>tabn 5<cr>", { desc = "Goto tab 5" })
map("n", "<Space>6", "<cmd>tabn 6<cr>", { desc = "Goto tab 6" })

-- Backspace delete in visual
map("v", "<BS>", "s")

local function smart_window_nav(direction)
  local initial_win = vim.api.nvim_get_current_win()

  -- Try to move in Neovim
  vim.cmd("wincmd " .. direction)

  local new_win = vim.api.nvim_get_current_win()

  -- If window didn't change, fallback to Hyprland
  if new_win == initial_win then
    -- Only try this if on Hyprland
    if os.getenv("XDG_SESSION_DESKTOP") == "Hyprland" then
      local hypr_dir_map = {
        h = "l", -- Hyprland directions are reversed compared to vim
        j = "u",
        k = "d",
        l = "r",
      }
      local hypr_dir = hypr_dir_map[direction]
      if hypr_dir then
        vim.fn.jobstart("hyprctl dispatch movefocus " .. hypr_dir)
      end
    end
  end
end

local directions = { h = "h", j = "j", k = "k", l = "l" }
for key, dir in pairs(directions) do
  vim.keymap.set("n", "<C-w>" .. key, function()
    smart_window_nav(dir)
  end, { noremap = true, silent = true })
end

vim.api.nvim_create_user_command("W", function()
  require("util.sudo_write").save_with_sudo()
end, {})

vim.cmd([[
cnoreabbrev <expr> w getcmdtype() == ':' && getcmdline() ==# 'w' ? 'W' : 'w'
]])
