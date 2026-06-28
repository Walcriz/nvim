return {
  {
    "windwp/nvim-spectre",
    enabled = not vim.g.walcriz.core.minimal,

    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },
}
