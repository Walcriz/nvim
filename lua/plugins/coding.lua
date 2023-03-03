return {

	-- snippets
	-- {
	-- 	"L3MON4D3/LuaSnip",
	-- 	build = (not jit.os:find("Windows")) and "make install_jsregexp" or nil,
	-- 	dependencies = {
	-- 		"rafamadriz/friendly-snippets",
	-- 		config = function()
	-- 			require("luasnip.loaders.from_vscode").lazy_load()
	-- 		end,
	-- 	},
	-- 	opts = {
	-- 		history = true,
	-- 		delete_check_events = "TextChanged",
	-- 	},
	-- 	-- stylua: ignore
	-- 	keys = {
	-- 		{
	-- 			"<tab>",
	-- 			function()
	-- 				return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
	-- 			end,
	-- 			expr = true, silent = true, mode = "i",
	-- 		},
	-- 		{ "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
	-- 		{ "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
	-- 	},
	-- },

	-- auto pairs
	{
		"echasnovski/mini.pairs",
		lazy = false,
		config = function(_, opts)
			require("mini.pairs").setup(opts)
		end,
	},

	-- Commentary
	{ "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
	{ "tpope/vim-commentary" },

	-- better text-objects
	{
		"echasnovski/mini.ai",
		-- keys = {
			--   { "a", mode = { "x", "o" } },
			--   { "i", mode = { "x", "o" } },
			-- },
			event = "VeryLazy",
			dependencies = { "nvim-treesitter-textobjects" },
			opts = function()
				local ai = require("mini.ai")
				return {
					n_lines = 500,
					custom_textobjects = {
						o = ai.gen_spec.treesitter({
							a = { "@block.outer", "@conditional.outer", "@loop.outer" },
							i = { "@block.inner", "@conditional.inner", "@loop.inner" },
						}, {}),
						f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
						c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
					},
				}
			end,
			config = function(_, opts)
				require("mini.ai").setup(opts)
				-- register all text objects with which-key
				if require("util").has("which-key.nvim") then
					---@type table<string, string|table>
					local i = {
						[" "] = "Whitespace",
						['"'] = 'Balanced "',
						["'"] = "Balanced '",
						["`"] = "Balanced `",
						["("] = "Balanced (",
						[")"] = "Balanced ) including white-space",
						[">"] = "Balanced > including white-space",
						["<lt>"] = "Balanced <",
						["]"] = "Balanced ] including white-space",
						["["] = "Balanced [",
						["}"] = "Balanced } including white-space",
						["{"] = "Balanced {",
						["?"] = "User Prompt",
						_ = "Underscore",
						a = "Argument",
						b = "Balanced ), ], }",
						c = "Class",
						f = "Function",
						o = "Block, conditional, loop",
						q = "Quote `, \", '",
						t = "Tag",
					}
					local a = vim.deepcopy(i)
					for k, v in pairs(a) do
						a[k] = v:gsub(" including.*", "")
					end

					local ic = vim.deepcopy(i)
					local ac = vim.deepcopy(a)
					for key, name in pairs({ n = "Next", l = "Last" }) do
						i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
						a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
					end
					require("which-key").register({
						mode = { "o", "x" },
						i = i,
						a = a,
					})
				end
			end,
		},
	}
