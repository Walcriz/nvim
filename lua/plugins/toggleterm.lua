return {
	-- Toggle term
	{
		"akinsho/toggleterm.nvim",
		opts = {
			tools = {
				-- Lazygit
				-- lazygit = {
				-- 	term_opts = {
				-- 		cmd = "lazygit",
				-- 		direction = "float",
				-- 	},

				-- 	toggle_key = "<leader>gg",
				-- },

				terminal = {
					term_opts = {
						cmd = "powershell",
					},
					toggle_key = "<leader>te",
				},
			},
			defaults = {
				highlights = {
					border = "TelescopeNormal",
					background = "TelescopeNormal",
				},
			},
		},
		keys = {
			{ "<C-W>h", [[<Cmd>wincmd h<CR>]], mode = "t" },
			{ "<C-W>j", [[<Cmd>wincmd j<CR>]], mode = "t" },
			{ "<C-W>k", [[<Cmd>wincmd k<CR>]], mode = "t" },
			{ "<C-W>l", [[<Cmd>wincmd l<CR>]], mode = "t" },
		},
		config = function(_, opts)
			require("toggleterm").setup()
			local util = require("lazy.core.util")

			local Terminal = require("toggleterm.terminal").Terminal

			for tool, options in pairs(opts.tools) do
				local term_opts = opts.defaults
				for k, v in pairs(options.term_opts) do
					term_opts[k] = v
				end

                -- stylua: ignore

				local tool_terminal = Terminal:new(term_opts)

				function toggle()
					tool_terminal:toggle()
				end

				vim.keymap.set("n", options.toggle_key, function()
					toggle()
				end, {
					noremap = true,
					silent = true,
					desc = "Toggle " .. tool,
				})
			end
		end,

		event = "VeryLazy",
	},
}
