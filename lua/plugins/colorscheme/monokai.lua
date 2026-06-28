return {
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,

    opts = {
      appearance = {
        transparent_background = false,
        terminal_colors = true,
        devicons = true,
        filter = "pro",
        inc_search = "background",
      },

      styles = {
        comment = { italic = true },
        keyword = { italic = true },
        type = { italic = true },
        storageclass = { italic = true },
        structure = { italic = true },
        parameter = { italic = false },
        annotation = { italic = false },
        tag_attribute = { italic = false },
      },

      background_clear = {
        "toggleterm",
        "telescope",
        "renamer",
        "notify",
      },

      plugins = {
        bufferline = {
          underline_selected = false,
          underline_visible = false,
          underline_fill = false,
          bold = true,
        },
        indent_blankline = {
          context_highlight = "default",
          context_start_underline = false,
        },
      },

      palette = {
        -- Optional: uncomment and tweak for a slightly deeper Monokai feel.
        -- background = "#1b1b1b",
        -- text = "#f8f8f2",
      },

      highlights = {
        -- Optional highlight overrides go here.
      },
    },

    config = function(_, opts)
      require("monokai-pro").setup({
        transparent_background = opts.appearance.transparent_background,
        terminal_colors = opts.appearance.terminal_colors,
        devicons = opts.appearance.devicons,
        filter = opts.appearance.filter,
        styles = opts.styles,
        inc_search = opts.appearance.inc_search,
        background_clear = opts.background_clear,
        plugins = opts.plugins,

        override_palette = function()
          return opts.palette
        end,

        override = function()
          return opts.highlights
        end,
      })

      vim.cmd.colorscheme("monokai-pro")
    end,
  },
}
