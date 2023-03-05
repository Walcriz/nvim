return {
	{
		"OmniSharp/omnisharp-vim",
		ft = "cs",
        event = { "BufReadPre", "BufNewFile" },
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

            local augroup = require("util").augroup("omnisharp")
            require("util").autocmd("FileType", {
                pattern = "cs",
                group = augroup,
                callback = function()
                    -- Keybinds
                    local map = require("util").map
                    map("n", "gh", "<Plug>(omnisharp_documentation)", { desc = "Show documentation", silent = true, buffer = true } )
                    map("n", "gd", "<Plug>(omnisharp_go_to_definition)", { desc = "Go to definition", silent = true, buffer = true, } )
                    map("n", "rr", "<Plug>(omnisharp_rename)", { desc = "Rename variable or function", silent = true, buffer = true, } )
                    map("n", "gr", "<Plug>(omnisharp_find_usages)", { desc = "Find usages", silent = true, buffer = true, })
                    map("n", "gi", "<Plug>(omnisharp_find_implementations)", { desc = "Find implementations", silent = true, buffer = true, })

                    map("n", "<Leader>gpd", "<Plug>(omnisharp_preview_definition)", { desc = "Preview definition", silent = true, buffer = true, })
                    map("n", "<Leader>gpi", "<Plug>(omnisharp_preview_implementations)", { desc = "Preview implementations", silent = true, buffer = true, })
                    map("n", "<Leader>gt", "<Plug>(omnisharp_type_lookup)", { desc = "Lookup type", silent = true, buffer = true, })
                    map("n", "<Leader>gfs", "<Plug>(omnisharp_find_symbol)", { desc = "Find symbol", silent = true, buffer = true, })
                    map("n", "<Leader>ru", "<Plug>(omnisharp_fix_usings)", { desc = "Fix usings", silent = true, buffer = true, })

                    map("n", "<leader>rr", "<Plug>(omnisharp_code_actions)", { desc = "Do code action", silent = true, buffer = true, })
                    map("x", "<leader>rr", "<Plug>(omnisharp_code_actions)", { desc = "Do code action", silent = true, buffer = true, })
                    map("n", "<Leader>r.", "<Plug>(omnisharp_code_action_repeat)", { desc = "Repeat action", silent = true, buffer = true, })
                    map("x", "<Leader>r.", "<Plug>(omnisharp_code_action_repeat)", { desc = "Repeat action", silent = true, buffer = true, })

                    map("n", "<Leader>r=", "<Plug>(omnisharp_code_format)", { desc = "Format code", silent = true, buffer = true, })

                    map("n", "<Leader>or", "<Plug>(omnisharp_restart_server)", { desc = "Restart server", silent = true, buffer = true, })
                    map("n", "<Leader>ot", "<Plug>(omnisharp_start_server)", { desc = "Start server", silent = true, buffer = true, })
                    map("n", "<Leader>op", "<Plug>(omnisharp_stop_server)", { desc = "Stop server", silent = true, buffer = true, })

                    map("n", "<Leader>dc", "<Plug>(omnisharp_global_code_check)", { desc = "Do code check", silent = true, buffer = true, })
                    map("n", "<leader>da", "<Plug>(omnisharp_run_test)>", { desc = "Run all tests", silent = true, buffer = true, })
                    map("n", "<leader>dd", "<Plug>(omnisharp_run_test)>", { desc = "Debug test", silent = true, buffer = true, })
                    map("n", "<leader>df", "<Plug>(omnisharp_run_test)>", { desc = "Run tests in file", silent = true, buffer = true, })
                end
            })

		end,
		dependencies = {
			"dense-analysis/ale",
            "neoclide/coc.nvim"
		},
	},
}
