return {
	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = { "mfussenegger/nvim-jdtls" },
		opts = {
			servers = {
				jdtls = {
					mason = true,
					settings = function()
						-- use this function notation to build some variables
						local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
						local root_dir = require("jdtls.setup").find_root(root_markers)

						-- calculate workspace dir
						local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
						local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name
						os.execute("mkdir " .. workspace_dir)

						local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
						extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

						-- get the mason install path
						local install_path = require("mason-registry").get_package("jdtls"):get_install_path()

						-- get the current OS
						local os
						if vim.fn.has("macunix") then
							os = "mac"
						elseif vim.fn.has("win32") then
							os = "win"
						else
							os = "linux"
						end

						-- return the server config
						return {
							cmd = {
								"java",
								"-Declipse.application=org.eclipse.jdt.ls.core.id1",
								"-Dosgi.bundles.defaultStartLevel=4",
								"-Declipse.product=org.eclipse.jdt.ls.core.product",
								"-Dlog.protocol=true",
								"-Dlog.level=ALL",
								"-javaagent:" .. install_path .. "/lombok.jar",
								"-Xms1g",
								"--add-modules=ALL-SYSTEM",
								"--add-opens",
								"java.base/java.util=ALL-UNNAMED",
								"--add-opens",
								"java.base/java.lang=ALL-UNNAMED",
								"-jar",
								vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
								"-configuration",
								install_path .. "/config_" .. os,
								"-data",
								workspace_dir,
							},
							root_dir = root_dir,
							settings = {
								java = {
									-- jdt = {
									--   ls = {
									--     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
									--   }
									-- },
									eclipse = {
										downloadSources = true,
									},
									configuration = {
										updateBuildConfiguration = "interactive",
										-- runtimes = {
										--   {
										--     name = "JavaSE-17",
										--     path = "/home/jrakhman/.sdkman/candidates/java/17.0.4-oracle",
										--   },
										-- },
									},
									maven = {
										downloadSources = true,
									},
									implementationsCodeLens = {
										enabled = true,
									},
									referencesCodeLens = {
										enabled = true,
									},
									references = {
										includeDecompiledSources = true,
									},
									inlayHints = {
										parameterNames = {
											enabled = "all", -- literals, all, none
										},
									},
									format = {
										enabled = false,
									},
								},
								signatureHelp = { enabled = true },
								completion = {
									favoriteStaticMembers = {
										"org.hamcrest.MatcherAssert.assertThat",
										"org.hamcrest.Matchers.*",
										"org.hamcrest.CoreMatchers.*",
										"org.junit.jupiter.api.Assertions.*",
										"java.util.Objects.requireNonNull",
										"java.util.Objects.requireNonNullElse",
										"org.mockito.Mockito.*",
									},
								},
								contentProvider = { preferred = "fernflower" },
								extendedClientCapabilities = extendedClientCapabilities,
								sources = {
									organizeImports = {
										starThreshold = 9999,
										staticStarThreshold = 9999,
									},
								},
								codeGeneration = {
									toString = {
										template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
									},
									useBlocks = true,
								},
							},

							flags = {
								allow_incremental_sync = true,
							},
							init_options = {
								bundles = {},
							},
						}
					end,
				},
			},

			setup = {
				jdtls = function(_, opts)
					require("util").on_attach(function(client, buffer)
						if client.name == "jdtls" then
							require("jdtls").start_or_attach(opts.settings())
						end
					end)
				end,
			},
		},
	},
}
