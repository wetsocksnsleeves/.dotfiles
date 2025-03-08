return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        config = function()
            require("mason-lspconfig").setup {
                ensure_installed = { "lua_ls", "clangd", "ltex", "marksman", "ts_ls" },
            }
        end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            -- Cursor hover time configuration 
            vim.o.updatetime = 250
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
                callback = function()
                    vim.diagnostic.open_float(nil, { focus = false })
                end
            })

            -- On attach function to use hover window diagnostics
            local on_attach = function(client, bufnr)
                -- Enable hover window diagnostics
                vim.api.nvim_create_autocmd("CursorHold", {
                  buffer = bufnr,
                  callback = function()
                    local opts = {
                      focusable = false,

                      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                      border = 'rounded',
                      source = 'always',
                      prefix = ' ',
                      scope = 'cursor',
                    }
                    vim.diagnostic.open_float(nil, opts)
                  end
                })
            end

            -- Setups
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_nvim_lsp.default_capabilities()
            -- capabilities.textDocument.completion.completionItem.snippetSupport = true
            )

            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
            lspconfig.clangd.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                cmd = { "clangd", "--clang-tidy" },
            })
            lspconfig.ltex.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
            lspconfig.marksman.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
            lspconfig.pyright.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
            lspconfig.ts_ls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
            -- lspconfig.denols.setup({
            --     capabilities = capabilities,
            -- })
            lspconfig.tailwindcss.setup({
                on_attach = on_attach,
                filetypes = {
                    'html',
                    'javascript',
                    'javascriptreact',
                    'typescript',
                    'typescriptreact',
                },
                capabilities = capabilities,
            })
            lspconfig.eslint.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                -- cmd = { "node", vim.fn.exepath("node_modules/.bin/eslint") },
                cmd = { "eslint_d" },
                settings = {
                    workingDirectories = { mode = "auto" },
                },
            })

            -- Key bindings
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
        end,
    },
}
