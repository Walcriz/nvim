local augroup = require("util").augroup
local autocmd = require("util").autocmd
local setuptabs = require("util").setuptabs

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

autocmd("BufWinEnter", {
  group = augroup("format_options"),
  callback = function()
    -- FILE SETTINGS --
    vim.opt.formatoptions = "jcrqlnt"
  end
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
-- autocmd("BufWritePre", {
-- 	group = augroup("del_whitespace_line"),
-- 	callback = function()
-- 		vim.cmd([[
-- 		let l = line(".")
-- 		let c = col(".")
-- 		%s/\(\s*\n\)\+\%$//ge
-- 		call cursor(l, c)
-- 		]])
-- 	end,
-- })

-- Repace groups of empty or whitespaces-only lines with one empty line
-- autocmd("BufWritePre", {
-- 	group = augroup("whitespace_replace"),
-- 	callback = function()
-- 		vim.cmd([[
-- 		let l = line(".")
--     let c = col(".")
-- 		%s/\(\s*\n\)\{3,}/\r\r/ge
-- 		call cursor(l, c)
-- 		]])
-- 	end,
-- })

-- Delete trailing whitespaces
autocmd("BufWritePre", {
  group = augroup("del_whitespace_trailing"),
  callback = function()
    vim.cmd([[
		let l = line(".")
		let c = col(".")
		%s/\s\+$//ge
		call cursor(l, c)
		]])
  end,
})


local profiles = require("config.tabprofiles")
autocmd({ "BufRead" }, {
  callback = function()
    local editorconfig = vim.b.editorconfig
    if editorconfig and (editorconfig.indent_style or editorconfig.indent_size or editorconfig.tab_width) then
      return
    end

    local guess = require("guess-indent").guess_from_buffer()
    if guess == nil then
      local profile = profiles.lang[vim.bo.filetype]
      if not profile == nil then
        setuptabs(vim.opt_local, profile)
      end
    else
      require("util").set_indent(guess)
    end
  end,
})

autocmd("BufRead", {
  callback = function()
    vim.cmd([[
			nmap <nowait> gu gR
		]])
  end,
})
