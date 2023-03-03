
return {
	{
		"neoclide/coc.nvim",
		branch = "release",
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
		},
		opts = {
			ensure_installed = {
				'coc-clangd',
				'coc-css',
				'coc-cssmodules',
				'coc-diagnostic',
				'coc-dictionary',
				'coc-docker',
				'coc-eslint',
				'coc-git',
				'coc-highlight',
				'coc-html',
				'coc-java',
				'coc-json',
				'coc-marketplace',
				'coc-prettier',
				'coc-project',
				'coc-pyright',
				'coc-sh',
				'coc-styled-components',
				'coc-svg',
				'coc-tsserver',
				'coc-vimlsp',
				'coc-xml',
				'coc-yaml',
				'coc-lists',
				'coc-snippets',
			},
		},
		config = function(_, opts)
			vim.g.coc_global_extensions = opts.ensure_installed

			vim.cmd([[
			" Add `:Format` command to format current buffer.
			command! -nargs=0 Format :call CocAction('format')
			" Add `:Fold` command to fold current buffer.
			command! -nargs=? Fold :call     CocAction('fold', <f-args>)
			" Add `:OR` command for organize imports of the current buffer.
			command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')


			function! s:DiagnosticNotify() abort
			  let l:info = get(b:, 'coc_diagnostic_info', {})
			  if empty(l:info) | return '' | endif
			  let l:msgs = []
			  let l:level = 'info'
			   if get(l:info, 'warning', 0)
				let l:level = 'warn'
			  endif
			  if get(l:info, 'error', 0)
				let l:level = 'error'
			  endif

			  if get(l:info, 'error', 0)
				call add(l:msgs, ' Errors: ' . l:info['error'])
			  endif
			  if get(l:info, 'warning', 0)
				call add(l:msgs, ' Warnings: ' . l:info['warning'])
			  endif
			  if get(l:info, 'information', 0)
				call add(l:msgs, ' Infos: ' . l:info['information'])
			  endif
			  if get(l:info, 'hint', 0)
				call add(l:msgs, ' Hints: ' . l:info['hint'])
			  endif
			  let l:msg = join(l:msgs, "\n")
			  if empty(l:msg) | let l:msg = ' All OK' | endif
			  call v:lua.coc_diag_notify(l:msg, l:level)
			endfunction

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
			]])

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

			function coc_diag_notify(msg, level)
				local notify_opts = { title = "LSP Diagnostics", timeout = 500, on_close = reset_coc_diag_record }
				-- if coc_diag_record is not {} then add it to notify_opts to key called "replace"
				if coc_diag_record ~= {} then
					notify_opts["replace"] = coc_diag_record.id
				end
				coc_diag_record = vim.notify(msg, level, notify_opts)
			end

			function reset_coc_diag_record(window)
				coc_diag_record = {}
			end
		end,
		event = "BufReadPre",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
	}
}
