return {
  {
    "mfussenegger/nvim-dap",
    enabled = vim.g.walcriz.core.lsp and not vim.g.walcriz.core.minimal,

    lazy = true,
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>ds", function() require("dap").continue() end, desc = "Start/Continue" },
      { "<leader>do", function() require("dap").continue() end, desc = "Step Over" },
      { "<leader>di", function() require("dap").continue() end, desc = "Step Into" },
      { "<F7>", function() require("dap").continue() end, desc = "Start/Continue" },
      { "<F8>", function() require("dap").continue() end, desc = "Step Over" },
      { "<F6>", function() require("dap").continue() end, desc = "Step Into" },
    },
    config = function()
      vim.api.nvim_create_user_command("Breakpoint", function()
        require("dap").toggle_breakpoint()
      end, {})

      vim.cmd("hi DapBreakpointColor guifg=#fa4848")
      vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "DapBreakpointColor",
        linehl = "",
        numhl = "",
      })
    end,
  },
}

