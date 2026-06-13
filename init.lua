local load = require("load").load_config

-- Install and bootstrap lazy.nvim
require("bootstrap")

load("conf")
load("opts")

-- Load hacks that may be needed for different platforms
require("hacks")

-- Setup lazy.nvim
require("lazy_setup")

load("maps")
load("auto")
