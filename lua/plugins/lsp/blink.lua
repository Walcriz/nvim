return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },

    version = "1.*",

    opts = {
      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        documentation = { auto_show = true },
        menu = {
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              vim.g.walcriz.env.using_nerd_font and { "kind_icon", "kind", gap = 1 } or { "kind", gap = 1 },
            },
          },
        },

        ghost_text = { enabled = true },

        trigger = {
          show_on_accept_on_trigger_character = true,
          show_on_x_blocked_trigger_characters = { "'", '"', "(", "{", "[" },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      keymap = {
        preset = "default",

        ["<C-n>"] = { "select_next" },
        ["<C-p>"] = { "select_prev" },
        ["<C-b>"] = { "scroll_documentation_up" },
        ["<C-f>"] = { "scroll_documentation_down" },
        ["<C-Space>"] = { "show" },
        ["<C-e>"] = { "hide" },

        ["<CR>"] = {
          "accept",
          "fallback",
        },
      },
    },

    opts_extend = { "sources.default" },
  },
}
