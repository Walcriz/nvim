return {
    -- cmdline tools and lsp servers
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        opts = {},
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

    -- Quick actions and refactorings
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter"
        },
        keys = {
            { "<leader>rk", "<Esc><Cmd>lua require('refactoring').select_refactor()<CR>", desc = "Select refactoring (refactoring.nvim)", mode = "v" },
        },
        config = function(_, opts)
            require("refactoring").setup(opts)
        end,
    },

    {
        "dense-analysis/ale",
        config = function()
            vim.g.ale_linters = {
                cs = { "OmniSharp" }
            }
        end,
        event = "VeryLazy"
    }
}
