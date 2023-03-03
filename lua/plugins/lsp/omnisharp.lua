return {
	{
		"OmniSharp/omnisharp-vim",
		event = "FileType cs",
		keys = {
			{ "gh", "<Plug>(omnisharp_documentation)", desc = "Show documentation" },
			{ "gd", "<Plug>(omnisharp_go_to_definition)", desc = "Go to definition" },
			{ "rr", "<Plug>(omnisharp_rename)", desc = "Rename variable or function" },
			{ "gr", "<Plug>(omnisharp_find_usages)", desc = ""},
			{ "gi", "<Plug>(omnisharp_find_implementations)", desc = ""},

			{ "<Leader>opd", "<Plug>(omnisharp_preview_definition)", desc = "Preview definition"},
			{ "<Leader>opi", "<Plug>(omnisharp_preview_implementations)", desc = "Preview implementations"},
			{ "<Leader>ot", "<Plug>(omnisharp_type_lookup)", desc = "Lookup type"},
			{ "<Leader>ofs", "<Plug>(omnisharp_find_symbol)", desc = "Find symbol"},
			{ "<Leader>ofx", "<Plug>(omnisharp_fix_usings)", desc = "Fix usings"},

			{ "<Leader>ogcc", "<Plug>(omnisharp_global_code_check)", desc = "Do code check"},
			{ "<A-CR>", "<Plug>(omnisharp_code_actions)", desc = "Do code actions"},
			{ "<A-CR>", "<Plug>(omnisharp_code_actions)", desc = "Do code actions", mode = "x"},
			{ "<Leader>o.", "<Plug>(omnisharp_code_action_repeat)", desc = "Repeat action"},
			{ "<Leader>o.", "<Plug>(omnisharp_code_action_repeat)", desc = "Repeat action", mode = "x"},

			{ "<Leader>o=", "<Plug>(omnisharp_code_format)", desc = "Format code"},

			{ "<Leader>osr", "<Plug>(omnisharp_restart_server)", desc = "Restart server"},
			{ "<Leader>ost", "<Plug>(omnisharp_start_server)", desc = "Start server"},
			{ "<Leader>osp", "<Plug>(omnisharp_stop_server)", desc = "Stop server"},
		},
		config = function()
			vim.g.omnicomplete_fetch_full_documentation = 1
			vim.g.OmniSharp_highlighting = 0
			vim.g.OmniSharp_selector_findusages = 'fzf'
			vim.g.OmniSharp_selector_ui = 'fzf'
			vim.g.OmniSharp_diagnostic_exclude_paths = {
				[[obj\\]],
				[[[Tt]emp\\]],
				[[\.nuget\\]],
				[[\<AssemblyInfo\.cs\>]],
			}
		end,
		dependencies = {
			"dense-analysis/ale"
		},
		event = "BufReadPre",
	},

	{
		"dense-analysis/ale",
		config = function()
			vim.g.ale_linters = {
				cs = { "OmniSharp" }
			}
		end,
	}
}
