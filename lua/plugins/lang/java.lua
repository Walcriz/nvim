return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "mfussenegger/nvim-jdtls" },
		opts = {
			servers = {
				jdtls = {
					settings = {
						java = {
							signatureHelp = { enabled = true },
							import = { enabled = true },
							rename = { enabled = true },
						},
					},
				},
			},
			setup = {
				jdtls = function(_, opts)
					local jdtls_install_location = vim.fn.stdpath("data") .. "/mason/jdtls"

					local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
					local workspace_dir = vim.fn.stdpath("data") .. "/workspace/" .. project_name

					local os = ""
					if vim.fn.has("windows") then
						os = "win"
					elseif vim.fn.has("linux") then
						os = "linux"
					else
						vim.notify("Failed to start jdtls: Not a supported operating system!", "error")
						return false
					end

					vim.notify("Testing", "info")

					require("jdtls").start_or_attach({
						-- The command that starts the language server
						-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
						cmd = {

							-- 💀
							"java", -- or '/path/to/java17_or_newer/bin/java'
							-- depends on if `java` is in your $PATH env variable and if it points to the right version.

							"-Declipse.application=org.eclipse.jdt.ls.core.id1",
							"-Dosgi.bundles.defaultStartLevel=4",
							"-Declipse.product=org.eclipse.jdt.ls.core.product",
							"-Dlog.protocol=true",
							"-Dlog.level=ALL",
							"-Xms1g",
							"--add-modules=ALL-SYSTEM",
							"--add-opens",
							"java.base/java.util=ALL-UNNAMED",
							"--add-opens",
							"java.base/java.lang=ALL-UNNAMED",

							"-jar",
							jdtls_install_location
								.. "/plugins/org.eclipse.equinox.launcher_"
								.. require("config").lsp.java.jdtls_launcher_version
								.. ".jar",

							"-configuration",
							jdtls_install_location .. "/config_" .. os,

							-- 💀
							-- See `data directory configuration` section in the README
							"-data",
							workspace_dir,
						},

						-- 💀
						-- This is the default if not provided, you can remove it. Or adjust as needed.
						-- One dedicated LSP server & client will be started per unique root_dir
						root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),

						-- Here you can configure eclipse.jdt.ls specific settings
						-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
						-- for a list of options
						settings = {
							java = {},
						},

						-- Language server `initializationOptions`
						-- You need to extend the `bundles` with paths to jar files
						-- if you want to use additional eclipse.jdt.ls plugins.
						--
						-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
						--
						-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
						init_options = {
							bundles = {},
						},
					})

					return true
				end,
			},
		},
	},
}
