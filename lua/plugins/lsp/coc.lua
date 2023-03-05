
return {
	{
		"neoclide/coc.nvim",
		branch = "master",
        build = "yarn install --frozen-lockfile",
		keys = {
			{"åg", "<Plug>(coc-diagnostic-prev)", desc = "Diagnostics previous"},
			{"äg", "<Plug>(coc-diagnostic-next)", desc = "Diagnostics next" },
			{"gb", "<Plug>(coc-cursors-word)", desc = "Highlight current word" },
			{"gd", "<Plug>(coc-definition)", desc = "Go to definition" },
			{"gy", "<Plug>(coc-type-definition)", desc = "Go to type definition" },
			{"gi", "<Plug>(coc-implementation)", desc = "Go to implementation" },
			{"gr", "<Plug>(coc-references)", desc = "Find references" },
			{"gh", "<Cmd>call CocAction('doHover')<CR>", desc = "Show documentation" },
			{"<leader>cc", "<Cmd>CocList marketplace<CR>", desc = "Search for coc plugins" },

            {"<leader>rr", "<Plug>(coc-codeaction-cursor)", desc = "Do code action"},
            {"<leader>ra", "<Plug>(coc-codeaction-selected)", desc = "Do code action for selected"},
            {"<leader>ra", "<Plug>(coc-codeaction-selected)", desc = "Do code action for selected", mode = "v"},
            {"<leader>rs", "<Plug>(coc-codeaction-source)", desc = "Do code action in whole buffer"},
            {"<leader>rf", "<Plug>(coc-fix-current)", desc = "Quickfix"},

            {"<leader>rl", "<Plug>(coc-codelens-action)", desc = "Do codelens action"},

            {"rr", "<Plug>(coc-rename)", desc = "Rename variable or function"},
		},
		opts = {
			ensure_installed = {
				'coc-clangd',
				'coc-css',
				'coc-cssmodules',
				'coc-diagnostic',
				'coc-docker',
				'coc-eslint',
				'coc-html',
				'coc-java',
				'coc-json',
				'coc-marketplace',
				'coc-prettier',
				'coc-project',
				'coc-pyright',
				'coc-sh',
				'coc-tsserver',
				'coc-vimlsp',
				'coc-xml',
				'coc-yaml',
				'coc-snippets',
			},
		},
		config = function(_, opts)
			vim.g.coc_global_extensions = opts.ensure_installed

			local coc_diag_record = {}

			function coc_status_notify(msg, level)
				local notify_opts = { title = "LSP Status", timeout = 500, hide_from_history = true, on_close = reset_coc_status_record }
				-- if coc_status_record is not {} then add it to notify_opts to key called "replace"
				if coc_status_record ~= {} then
					notify_opts["replace"] = coc_status_record.id
				end
				coc_status_record = vim.notify(msg, level, notify_opts)
			end

			function reset_coc_status_record(window)
				coc_status_record = {}
			end

			local coc_diag_record = {}

			function reset_coc_diag_record(window)
				coc_diag_record = {}
			end

			local group = require("util").augroup("coc")
			require("util").autocmd("CursorHold", {
				group = group,
				command = "silent call CocActionAsync('highlight')",
				desc = "Highlight symbol under cursor on CursorHold",
			})

			vim.cmd([[
			" Add `:Format` command to format current buffer.
			command! -nargs=0 Format :call CocAction('format')
			" Add `:Fold` command to fold current buffer.
			command! -nargs=? Fold :call     CocAction('fold', <f-args>)
			" Add `:OR` command for organize imports of the current buffer.
			command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

			function! s:StatusNotify() abort
			  let l:status = get(g:, 'coc_status', '')
			  let l:level = 'info'
			  if empty(l:status) | return '' | endif
			  call v:lua.coc_status_notify(l:status, l:level)
			endfunction

			function! s:InitCoc() abort
			  execute "lua vim.notify('Initialized coc.nvim for LSP support', 'info', { title = 'LSP Status' })"
			endfunction

			" notifications
			autocmd User CocNvimInit call s:InitCoc()
			autocmd User CocDiagnosticChange call s:DiagnosticNotify()
			autocmd User CocStatusChange call s:StatusNotify()

            nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
            nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
            inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
            inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
            vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
            vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
			]])
		end,
        event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
	}
}
