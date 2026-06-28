return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      search = {
        multi_window = true,
      },

      modes = {
        char = {
          enabled = false
        }
      }
    },
    config = true,
    keys = {
      { "S", mode = { "n" }, function() require("flash").jump() end, desc = "Flash" },
    },
  }
}
