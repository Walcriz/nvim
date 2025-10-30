local opt = vim.opt

-- ETC --
opt.ruler = true
opt.showmatch = true
opt.showmode = true

opt.termguicolors = true

-- LINE NUMBERS --
opt.number = true
opt.relativenumber = true

-- EDITOR SETTINGS --
opt.confirm = true
opt.hidden = true
opt.backspace = "indent,eol,start"
opt.syntax = "enable"
-- opt.listchars = "eol:$,tab:>-,trail:.,nbsp:_,extends:+,precedes:+"
opt.virtualedit = "onemore"
opt.showmode = false
opt.laststatus = 2
opt.pumblend = 10
opt.pumheight = 10
opt.shortmess:append({ W = true, I = true, c = true })
opt.autowrite = true
opt.updatetime = 50

opt.scrolloff = 15
opt.wildmode = "longest:full,full"
opt.wrap = false

opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- UNDO SETTINGS --
local sysname = vim.loop.os_uname().sysname
if sysname:find("Windows") and true or false then
  opt.undodir = os.getenv("USERPROFILE") .. "/.vim/undodir"
else
  opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end

opt.undofile = true
opt.history = 1000
opt.undolevels = 10000
opt.updatetime = 200

-- COLUMN SETTINGS --
opt.signcolumn = "yes"

-- SEARCH SETTINGS --
opt.hlsearch = false
opt.ignorecase = true
opt.incsearch = true
opt.smartcase = true

-- FILE SETTINGS --
-- opt.formatoptions = "jcroqlnt"

-- TABS AND SPACES SETTINGS -- NOTE: NOW SET IN config/tabprofiles.lua
-- opt.tabstop = 2
-- opt.softtabstop = 2
-- opt.shiftwidth = 2
-- opt.expandtab = true

-- WINDOW SETTINGS --
opt.splitbelow = true
opt.splitright = true
opt.winminwidth = 5

-- CLIPBOARD SYNC --
opt.clipboard = "unnamedplus"

-- MOUSE SETTINGS --
opt.mousefocus = true
opt.mouse:append("a")

vim.o.sessionoptions="buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
