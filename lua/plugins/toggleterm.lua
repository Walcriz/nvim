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
					term_opts = {},
					toggle_key = "<leader>te",
				},
			},
			defaults = {
				direction = "float",
				winblend = 0,
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
			{ "<C-h>", [[<Cmd>wincmd h<CR>]], mode = "t" },
			{ "<C-j>", [[<Cmd>wincmd j<CR>]], mode = "t" },
			{ "<C-k>", [[<Cmd>wincmd k<CR>]], mode = "t" },
			{ "<C-l>", [[<Cmd>wincmd l<CR>]], mode = "t" },
		},
		config = function(_, opts)
			require("toggleterm").setup()

			local Terminal = require("toggleterm.terminal").Terminal

			for tool, options in pairs(opts.tools) do
				local term_opts = vim.deepcopy(opts.defaults)
                -- stylua: ignore
                for k,v in pairs(options.term_opts) do term_opts[k] = v end

				local tool_terminal = Terminal:new(options.term_opts)

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
