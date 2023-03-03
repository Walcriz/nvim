
local opt = vim.opt

-- ETC --
opt.encoding = "utf-8"
opt.ruler = true
opt.showmatch = true
opt.showmode = true

-- LINE NUMBERS --
opt.number = true
opt.relativenumber = true

-- EDITOR SETTINGS --
opt.confirm = true
opt.hidden = true
opt.backspace = "indent,eol,start"
opt.syntax = "enable"
opt.listchars = "eol:$,tab:>-,trail:.,nbsp:_,extends:+,precedes:+"
opt.virtualedit = "onemore"
opt.showmode = false
opt.laststatus = 2
opt.pumblend = 10
opt.pumheight = 10
opt.shortmess:append { W = true, I = true, c = true }
opt.autowrite = true

opt.scrolloff = 15
opt.wildmode = "longest:full,full"
opt.wrap = false

opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- UNDO SETTINGS --
opt.undodir = "~/.vim/undodir"
opt.undofile = true
opt.history = 1000
opt.undolevels = 10000
opt.updatetime = 200

-- COLUMN SETTINGS --
opt.signcolumn = "yes"
opt.colorcolumn = "100"

-- SEARCH SETTINGS --
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.smartcase = true

-- FILE SETTINGS --
opt.formatoptions = "jcroqlnt"

-- TABS AND SPACES SETTINGS --
opt.smartindent = true
opt.smarttab = true
opt.tabstop = 2
opt.expandtab = true

-- WINDOW SETTINGS --
opt.splitbelow = true
opt.splitright = true
opt.winminwidth = 5

-- CLIPBOARD SYNC --
opt.clipboard = "unnamedplus"
