return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = not vim.g.walcriz.core.minimal,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {
      heading = {
        sign = true,
        position = "inline",
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        width = "full",
        backgrounds = {
          "MarkdownLevelBackground",
          "MarkdownLevelBackground",
          "MarkdownLevelBackground",
          "MarkdownLevelBackground",
          "MarkdownLevelBackground",
          "MarkdownLevelBackground",
        },
        foregrounds = {
          "MarkdownLevel1",
          "MarkdownLevel2",
          "MarkdownLevel3",
          "MarkdownLevel4",
          "MarkdownLevel5",
          "MarkdownLevel6",
        },
      },
    },
  },
}
