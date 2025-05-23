local Util = require("util")
local map = Util.map

-- Fix Tab being C-I
-- vim.cmd([[
-- let &t_TI = "\<Esc>[>4;2m"
-- let &t_TE = "\<Esc>[>4;m"
-- ]])

-- map("i", "<C-H>", "<C-W>", { desc = "" })
map("i", "<C-BS>", "<C-W>", { noremap = true, silent = true })

-- Go back to previous file
map("i", "<C-b>", "<C-6>", { desc = "Jump back to previous file" })
map("n", "<C-b>", "<C-6>", { desc = "Jump back to previous file" })

-- Make CTRL + Backspace work
-- map("i", "<C-H>", "<C-W>", { desc = "Make CTRL + Backspace Work" })

-- Better buffer navigation
-- map("i", "<A-j>", "<cmd>bp", { desc = "Go to previous buffer" })
-- map("i", "<A-k>", "<cmd>bn", { desc = "Go to next buffer" })

-- Move to window using the <ctrl> hjkl keys
-- map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
-- map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
-- map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
-- map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
-- map("n", "<S-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
-- map("n", "<S-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
-- map("v", "<S-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
-- map("v", "<S-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Clear search with <esc>
-- map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
-- map(
--   "n",
--   "<leader>ur",
--   "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
--   { desc = "Redraw / clear hlsearch / diff update" }
-- )

-- Replace selected
-- map("v", "r", '"hy:%s/<C-r>h//gc<left><left><left>')

-- Add undo break-points
-- map("i", ",", ",<c-g>u")
-- map("i", ".", ".<c-g>u")
-- map("i", ";", ";<c-g>u")

-- better indenting
-- map("v", "<Tab>", "<")
-- map("v", "<S-Tab>", ">")

-- lazy
map("n", "<leader>dp", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- new file
-- map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
-- map("n", "fq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- toggle options
-- map("n", "<leader>uf", require("lazy.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })
-- map("n", "<leader>us", function()
--   Util.toggle("spell")
-- end, { desc = "Toggle Spelling" })
-- map("n", "<leader>uw", function()
--   Util.toggle("wrap")
-- end, { desc = "Toggle Word Wrap" })
-- map("n", "<leader>ul", function()
--   Util.toggle("relativenumber", true)
--   Util.toggle("number")
-- end, { desc = "Toggle Line Numbers" })
-- map("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
-- local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
-- map("n", "<leader>uc", function()
--   Util.toggle("conceallevel", false, { 0, conceallevel })
-- end, { desc = "Toggle Conceal" })

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

-- Undo
-- map("i", "<C-z>", "<C-o>u")
-- map("v", "<C-z>", "u")

-- Backspace delete in visual
map("v", "<BS>", "s")

local function smart_window_nav(direction)
  local initial_win = vim.api.nvim_get_current_win()

  -- Try to move in Neovim
  vim.cmd('wincmd ' .. direction)

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
  vim.keymap.set('n', '<C-w>' .. key, function() smart_window_nav(dir) end, { noremap = true, silent = true })
end
