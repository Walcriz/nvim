
return {
	{
		"neoclide/coc.nvim",
		branch = "release",
		keys = {
			{"åg", "<Plug>(coc-diagnostic-prev)", desc = "Diagnostics previous"},
			{"äg", "<Plug>(coc-diagnostic-next)", desc = "Diagnostics next" },
			{"gb", "<Plug>(coc-cursors-word)", desc = "Something I guess" },
			{"gd", "<Plug>(coc-definition)", desc = "Show definition" },
			{"gy", "<Plug>(coc-type-definition)", desc = "Go to type definition" },
			{"gi", "<Plug>(coc-implementation)", desc = "Go to implementation" },
			{"gr", "<Plug>(coc-references)", desc = "Find references" },
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
				'coc-metals',
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
			]])
		end,
		lazy = false,
	}
}
