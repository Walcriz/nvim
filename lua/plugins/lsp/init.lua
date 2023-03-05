return {
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
