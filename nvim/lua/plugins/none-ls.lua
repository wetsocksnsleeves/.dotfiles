return {
    "nvimtools/none-ls.nvim",
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                -- General purpose
                null_ls.builtins.formatting.prettier.with({
                    extra_args = {
                        "--use-tabs=false",
                        "--tab-width=4",
                    },
                }),
                -- C
                null_ls.builtins.formatting.clang_format,
                -- Python
                null_ls.builtins.formatting.black.with({
                    extra_args = { "--line-length", "79" },
                }),
                null_ls.builtins.diagnostics.pylint.with({
                }),
                -- Go - gopls handles formatting (gofumpt), goimports fixes imports
                null_ls.builtins.formatting.goimports.with({
                    command = vim.fn.expand("~/.local/share/mise/shims/goimports"),
                }),
                null_ls.builtins.diagnostics.golangci_lint.with({
                    command = vim.fn.expand("~/.local/share/mise/shims/golangci-lint"),
                }),
            },
            autostart = true,
        })

        -- Key binds
        vim.keymap.set("n", "<leader>gf", function()
            print("File formatted")
            vim.lsp.buf.format()
        end, { desc = "Format file" })

        -- Format on write
        -- vim.api.nvim_create_autocmd("BufWritePre", {
        --     callback = function()
        --         vim.lsp.buf.format()
        --     end,
        -- })
    end,
}
