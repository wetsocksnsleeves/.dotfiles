return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        opts = {
            ensure_installed = {
                "ts_ls",
            },
        },
        config = function()
            require("mason").setup()
        end,
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        config = function()
            require("mason-null-ls").setup({
                -- C - clang
                -- Python - pylint for linting, black for formatting
                ensure_installed = { "clang-format", "black", "pylint" },
            })
        end,
    }
}
