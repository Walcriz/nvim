local augroup = require("util").augroup
local autocmd = require("util").autocmd

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	command = "checktime",
})

-- resize splits if window got resized
autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- go to last loc when opening a buffer
autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- close some filetypes with <q>
autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"qf",
		"help",
		"man",
		"notify",
		"lspinfo",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"PlenaryTestPopup",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- wrap and check for spell in text filetypes
autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Delete empty lines at end of file
autocmd("BufWritePre", {
	group = augroup("del_whitespace_line"),
	callback = function()
		vim.cmd([[%s/\(\s*\n\)\+\%$//ge]])
	end,
})

-- Repace groups of empty or whitespaces-only lines with one empty line
autocmd("BufWritePre", {
	group = augroup("whitespace_replace"),
	callback = function()
		vim.cmd([[%s/\(\s*\n\)\{3,}/\r\r/ge]])
	end,
})

-- Delete trailing whitespaces
autocmd("BufWritePre", {
	group = augroup("del_whitespace_trailing"),
	callback = function()
		vim.cmd([[%s/\s\+$//ge]])
	end,
})

-- Bufferline
autocmd({ "BufWritePost", "TextChanged", "TextChangedI" }, {
	group = augroup("update_line"),
	callback = function()
		vim.cmd([[call lightline#update()]])
	end,
})

-- Checkboxes markdown
autocmd("BufReadPre", {
	pattern = "*.md",
	group = augroup("checkbox_markdown"),
	callback = function()
		vim.keymap.set("n", "<leader><CR>", "<Plug>WorkbenchToggleCheckbox", { desc = "Check" })
		vim.keymap.set("i", "<A-x>", "<C-o><Plug>WorkbenchToggleCheckbox", { desc = "Check" })
	end,
})

-- More file types
local fileTypeGroup = augroup("auto_file_type")

autocmd({ "BufRead", "BufEnter" }, {
	pattern = "*.astro",
	group = fileTypeGroup,
	callback = function()
		vim.cmd("set filetype=astro")
	end,
})
