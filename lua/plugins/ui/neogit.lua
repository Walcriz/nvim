return {
  {
    "NeogitOrg/neogit",
    enabled = vim.g.neogit_session or (not vim.g.walcriz.core.minimal and vim.g.walcriz.core.use_git),
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit kind=split<CR>", desc = "Open neogit" },
    },
    opts = {
      kind = vim.g.neogit_session and "replace" or "split",
      mappings = {
        status = {
          ["<cr>"] = vim.g.neogit_session and "TabOpen" or "GoToFile",
        },
      },
    },
    config = function(_, opts)
      require("neogit").setup(opts)

      if vim.g.neogit_session then
        vim.opt.switchbuf = "usetab,newtab"
        vim.opt.showtabline = 2

        vim.api.nvim_create_autocmd("FileType", {
          pattern = "NeogitStatus",
          callback = function(ev)
            vim.schedule(function()
              vim.keymap.del("n", "q", { buffer = ev.buf })
            end)
          end,
        })
      end
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
  },
}
