return {
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
          "williamboman/mason.nvim",
          "nvimtools/none-ls.nvim",
        },
        config = function()
          require("mason-null-ls").setup({
                ensure_installed = { "stylua", "clang-format", "black", "pylint"},
                -- C - clang 
                -- Python - pylint for linting, black for formatting
            })
        end,
    }
}
