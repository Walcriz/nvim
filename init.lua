local init = require("init")

-- Avoid freezing vim forever
if vim.fn.has("win32") then
	vim.keymap.set("n", "<C-z>", "<Nop>", { noremap = true })
	vim.keymap.set("i", "<C-c>", "<esc>", { noremap = true })
	vim.keymap.set("n", "<C-c>", "<esc>", { noremap = true })
	vim.keymap.set("v", "<C-c>", "<esc>", { noremap = true })
end

-- Initial setup and bootstrapping
init.init()

-- Sets up keybindings and colorscheme
init.after()
