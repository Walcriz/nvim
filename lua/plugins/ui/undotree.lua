return {
  {
    "mbbill/undotree",
    keys = {
      { "<leader>tu", "<Cmd>UndotreeToggle<CR>", desc = "Toggle undo tree window" },
    },
    config = function()
      vim.g.undotree_WindowLayout = 3
    end,
  },
}
