local opt = vim.opt

vim.g.mapleader = " "

-- ETC --
opt.termguicolors = true

-- LINE NUMBERS --
opt.number = true
opt.relativenumber = true

-- EDITOR SETTINGS --
opt.confirm = true
opt.hidden = true
opt.backspace = "indent,eol,start"
opt.virtualedit = "onemore"
opt.laststatus = 2
opt.pumheight = 10
opt.shortmess:append({ W = true, I = true, c = true })
opt.autowrite = true
opt.updatetime = 200

opt.scrolloff = 15
opt.wildmode = "longest:full,full"
opt.wrap = false

opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- UNDO SETTINGS --
local sysname = vim.loop.os_uname().sysname
if sysname:find("Windows") then
  opt.undodir = os.getenv("USERPROFILE") .. "/.vim/undodir"
else
  opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end

opt.undofile = true
opt.history = 1000
opt.undolevels = 10000

-- COLUMN SETTINGS --
opt.signcolumn = "yes"

-- SEARCH SETTINGS --
opt.hlsearch = false
opt.ignorecase = true
opt.incsearch = true
opt.smartcase = true

-- WINDOW SETTINGS --
opt.splitbelow = true
opt.splitright = true
opt.winminwidth = 5

-- CLIPBOARD SYNC --
opt.clipboard = "unnamedplus"
