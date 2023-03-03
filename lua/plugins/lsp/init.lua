return {
	  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {},
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(plugin, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },

  -- Quick actions and refactorings
  {
	  "ThePrimeagen/refactoring.nvim",
	  dependencies = {
		  "nvim-lua/plenary.nvim",
		  "nvim-treesitter/nvim-treesitter"
	  },
	  keys = {
		  { "<leader>re", "<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>", desc = "Extract selected function", mode = "v" },
		  { "<leader>rf", "<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>", desc = "Extract selected function to file", mode = "v" },
		  { "<leader>rv", "<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>", desc = "Extract selected variable", mode = "v" },
		  { "<leader>ri", "<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>", desc = "Inline selected variable", mode = "v" },

		  { "<leader>rb", "<Cmd>lua require('refactoring').refactor('Extract Block')<CR>", desc = "Extract block"},
		  { "<leader>rb", "<Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>", desc = "Extract block to file"},

		  { "<leader>ri", "<Cmd>lua require('refactoring').refactor('Inline Variable')<CR>", desc = "Inline variable"},

		  { "<leader>rr", "<Esc><Cmd>lua require('refactoring').select_refactor()<CR>", desc = "Select refactoring", mode = "v" },
	  },
	  config = function(_, opts)
		  require("refactoring").setup(opts)
	  end,
  }
}
