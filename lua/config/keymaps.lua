
local Util = require("util")
local map = Util.map;

map("i", "<C-H>", "<C-W>", { desc = "" })
map("i", "<C-H>", "<C-W>")

-- Make CTRL + Backspace work
map("i", "<C-H>", "<C-W>", { desc = "Make CTRL + Backspace Work" })

-- Better buffer navigation
map("i", "<A-j>", "<cmd>bp", { desc = "Go to previous buffer" })
map("i", "<A-j>", "<cmd>bn", { desc = "Go to next buffer" })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<S-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<S-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("v", "<S-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<S-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

-- Replace selected
map("v", "r", "\"hy:%s/<C-r>h//gc<left><left><left>")

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- better indenting
map("v", "<Tab>", "<gv")
map("v", "<S-Tab>", ">gv")

-- lazy
map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- toggle options
-- map("n", "<leader>uf", require("lazy.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })
map("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ul", function() Util.toggle("relativenumber", true) Util.toggle("number") end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })

-- floating terminal
map("n", "<leader>ft", function() Util.float_term(nil, { cwd = Util.get_root() }) end, { desc = "Terminal (root dir)" })
map("n", "<leader>fT", function() Util.float_term() end, { desc = "Terminal (cwd)" })
map("t", "<esc><esc>", "<c-\\><c-n>", {desc = "Enter Normal Mode"})

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- coc

local opts = {silent = true, noremap = false, expr = true, replace_keycodes = false, desc = "Accept autocomplete" }
map("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : v:lua.MiniPairs.cr()]], opts)
map("i", "<tab>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<TAB>"]], opts)

-- Snippets
vim.g.coc_snippet_next = '<TAB>'
vim.g.coc_snippet_prev = '<S-TAB>'

map("i", "<C-k>", "<Plug>(coc-snippets-expand-jump)", { desc = "Expand and jump in snippet" })

-- Undo
map("i", "<C-z>", "<C-o>u")
map("v", "<C-z>", "u")

-- Backspace delete in visual
map("v", "<BS>", "s")

-- Copy with right mouse
map("v", "<RightMouse>", "y")

-- Paste with mouse
map("c", "<RightMouse>", "<C-r>*")
map("i", "<RightMouse>", "<C-o>h<C-o>p")
map("n", "<RightMouse>", "p")

-- Surround in visual mode
map("v", "(", [[:s/\%V.*\%V/(&)<CR>:noh<cr><esc>`<]])
map("v", "{", [[:s/\%V.*\%V/{&}<CR>:noh<cr><esc>`<]])
map("v", "\"", [[:s/\%V.*\%V/"&"<CR>:noh<cr><esc>`<]])
map("v", "'", [[:s/\%V.*\%V/'&'<CR>:noh<cr><esc>`<]])
map("v", "[", [[:s/\%V.*\%V/[&]<CR>::noh<cr><esc>`<]])
map("v", "`", [[:s/\%V.*\%V/`&`<CR>:noh<cr><esc>`<]])
map("v", "<", [[:s/\%V.*\%V/<&><CR>:noh<cr><esc>`<]])
