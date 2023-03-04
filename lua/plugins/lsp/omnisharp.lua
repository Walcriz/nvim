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

			{ "<Leader>gpd", "<Plug>(omnisharp_preview_definition)", desc = "Preview definition"},
			{ "<Leader>gpi", "<Plug>(omnisharp_preview_implementations)", desc = "Preview implementations"},
			{ "<Leader>gt", "<Plug>(omnisharp_type_lookup)", desc = "Lookup type"},
			{ "<Leader>gfs", "<Plug>(omnisharp_find_symbol)", desc = "Find symbol"},
			{ "<Leader>ru", "<Plug>(omnisharp_fix_usings)", desc = "Fix usings"},

			{ "<leader>rr", "<Plug>(omnisharp_code_actions)", desc = "Do code action"},
			{ "<leader>rr", "<Plug>(omnisharp_code_actions)", desc = "Do code action", mode = "x"},
			{ "<Leader>r.", "<Plug>(omnisharp_code_action_repeat)", desc = "Repeat action"},
			{ "<Leader>r.", "<Plug>(omnisharp_code_action_repeat)", desc = "Repeat action", mode = "x"},

			{ "<Leader>r=", "<Plug>(omnisharp_code_format)", desc = "Format code"},

			{ "<Leader>or", "<Plug>(omnisharp_restart_server)", desc = "Restart server"},
			{ "<Leader>ot", "<Plug>(omnisharp_start_server)", desc = "Start server"},
			{ "<Leader>op", "<Plug>(omnisharp_stop_server)", desc = "Stop server"},

			{ "<Leader>dc", "<Plug>(omnisharp_global_code_check)", desc = "Do code check"},
            { "<leader>da", "<Plug>(omnisharp_run_test)>", desc = "Run all tests"},
            { "<leader>dd", "<Plug>(omnisharp_run_test)>", desc = "Debug test"},
            { "<leader>df", "<Plug>(omnisharp_run_test)>", desc = "Run tests in file"},
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
			"dense-analysis/ale",
            "neoclide/coc.nvim"
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
