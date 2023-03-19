local init = require("init")

-- Avoid freezing vim forever
if vim.fn.has("win32") then
	vim.keymap.set("n", "C-z", "<Nop>")
end

-- Initial setup and bootstrapping
init.init()

-- Sets up keybindings and colorscheme
init.after()
