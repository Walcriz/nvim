return {
    -- lspconfig
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
            { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            {
                "hrsh7th/cmp-nvim-lsp",
                cond = function()
                    return require("util").has("nvim-cmp")
                end,
            },
        },
        ---@class PluginLspOpts
        opts = {
            -- options for vim.diagnostic.config()
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = { spacing = 4, prefix = "●" },
                severity_sort = true,
            },
            -- Automatically format on save
            autoformat = true,
            -- options for vim.lsp.buf.format
            -- `bufnr` and `filter` is handled by the Neovim formatter,
            -- but can be also overridden when specified
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },
            -- LSP Server Settings
            ---@type lspconfig.options
            servers = {
                jsonls = {},
                lua_ls = {
                    -- mason = false, -- set to false if you don't want this server to be installed with mason
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                },
            },
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
            setup = {
                -- example to setup with typescript.nvim
                -- tsserver = function(_, opts)
                --   require("typescript").setup({ server = opts })
                --   return true
                -- end,
                -- Specify * to use this function as a fallback for any server
                -- ["*"] = function(server, opts) end,
            },
        },
        ---@param opts PluginLspOpts
        config = function(plugin, opts)
            -- setup autoformat
            require("plugins.lsp.format").autoformat = opts.autoformat
            -- setup formatting and keymaps
            require("util").on_attach(function(client, buffer)
                require("plugins.lsp.format").on_attach(client, buffer)
                require("plugins.lsp.keymaps").on_attach(client, buffer)
            end)

            -- diagnostics
            for name, icon in pairs(require("config").icons.diagnostics) do
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
            end
            vim.diagnostic.config(opts.diagnostics)

            local servers = opts.servers
            local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                }, servers[server] or {})

                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end
                require("lspconfig")[server].setup(server_opts)
            end

            -- temp fix for lspconfig rename
            -- https://github.com/neovim/nvim-lspconfig/pull/2439
            local mappings = require("mason-lspconfig.mappings.server")
            if not mappings.lspconfig_to_package.lua_ls then
                mappings.lspconfig_to_package.lua_ls = "lua-language-server"
                mappings.package_to_lspconfig["lua-language-server"] = "lua_ls"
            end

            local mlsp = require("mason-lspconfig")
            local available = mlsp.get_available_servers()

            local ensure_installed = {} ---@type string[]
            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                    if server_opts.mason == false or not vim.tbl_contains(available, server) then
                        setup(server)
                    else
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end
            end

            require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
            require("mason-lspconfig").setup_handlers({ setup })
        end,
    },

    -- coc.nvim
	{
		"neoclide/coc.nvim",

        ft = { -- Filetypes to load coc on
            "java",
            "xml",
        },

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
				'coc-diagnostic',
				'coc-java',
				'coc-xml',
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
	},

    -- formatters
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "mason.nvim" },
        opts = function()
            local nls = require("null-ls")
            return {
                sources = {
                    -- nls.builtins.formatting.prettierd,
                    nls.builtins.formatting.stylua,
                    nls.builtins.diagnostics.flake8,
                },
            }
        end,
    },

    -- Install lsp and stuff
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>dm", "<cmd>Mason<cr>", desc = "Mason" } },
        opts = {
            ensure_installed = {

            },
        },
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

    -- Fast errors :D
    {
        "dense-analysis/ale",
        config = function()
            vim.g.ale_linters = {
                cs = { "OmniSharp" }
            }
        end,
        event = { "BufReadPre", "BufNewFile" },
    },
}
