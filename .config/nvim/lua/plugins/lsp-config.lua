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
                opts = {
                        auto_install = true,
                },
                config = function()
                        require("mason-lspconfig").setup({
                                ensure_installed = { "lua_ls", "pyright" },
                        })
                end,
        },
        {
                "neovim/nvim-lspconfig",
                lazy = false,
                config = function()
                        -- Define helper function at the top level of config
                        local function get_python_path()
                            return vim.fn.expand("~/.pyenv/shims/python")
                        end

                        local capabilities = require("cmp_nvim_lsp").default_capabilities()
                        local lspconfig = require("lspconfig")
                        
                        lspconfig.lua_ls.setup({
                                capabilities = capabilities,
                        })
                        lspconfig.clangd.setup({
                                capabilities = capabilities,
                                cmd = { "clangd", "--clang-tidy" },
                        })
                        lspconfig.pyright.setup({
                                capabilities = capabilities,
                                filetypes = { "python" },
                                settings = {
                                    python = {
                                        pythonPath = get_python_path(),
                                        analysis = {
                                            autoSearchPaths = true,
                                            useLibraryCodeForTypes = true,
                                            diagnosticMode = "workspace",
                                        },
                                    },
                                },
                        })
                        vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
                        vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
                        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
                        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
                end,
        },
}
