return { -- Define custom indentation profiles for specific languages in this file
	default = { -- The default indentation profile
		usetabs = false, -- Whether or not to use tabs
		tabsize = 2, -- Visual size or amount of spaces for a tab
		visualtabsize = 4, -- What size a tab will show as (Specific to the default profile)
	},

	lang = { -- Define the indentation profiles here
		cs = { -- C#
			usetabs = false,
			tabsize = 4,
		},

		java = { -- Java
			usetabs = false,
			tabsize = 4,
		},

		python = { -- Python
			usetabs = true,
			tabsize = 2,
		},

		javascript = { -- Javascript
			usetabs = false,
			tabsize = 2,
		},

		typescript = { -- Typescript
			usetabs = false,
			tabsize = 2,
		},

		javascriptreact = { -- Javascript (jsx)
			usetabs = false,
			tabsize = 2,
		},

		typescriptreact = { -- Typescriptreact (tsx)
			usetabs = false,
			tabsize = 2,
		},

		lua = { -- Lua
			usetabs = true,
			tabsize = 2,
		},

		go = { -- GO
			usetabs = false,
			tabsize = 2,
		},
	},
}
