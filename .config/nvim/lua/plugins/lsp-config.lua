return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function() 
            require("mason-lspconfig").setup({
                ensure_installed = {"lua_ls", "clangd", "pyright"}
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
            lspconfig.clangd.setup({})
            lspconfig.pyright.setup({})
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, opts)
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        end
    }
}
