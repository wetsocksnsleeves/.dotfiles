vim.lsp.set_log_level 'debug'

-- Using nvim-lspconfig for default lsp configurations
vim.lsp.enable({
    "lua_ls",
    "ts_ls",
    "tailwindcss",
})

-- Key bindings
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>gr", "<CMD>Telescope lsp_references<CR>", { remap = true })
vim.keymap.set("n", "<leader>gk", "<CMD>Telescope lsp_implementations<CR>", { remap = true })
vim.keymap.set("n", "<leader>gd", "<CMD>Telescope lsp_definitions<CR>", { remap = true })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
