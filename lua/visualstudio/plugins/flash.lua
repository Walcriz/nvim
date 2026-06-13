return {
  {
    "folke/flash.nvim",
    lazy = false,
    opts = {},
    keys = {
      { "S", mode = { "n" }, function() require("flash").remote() end, desc = "Flash" },
    },
  }
}
