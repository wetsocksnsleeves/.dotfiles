return {
    "neovim/nvim-lspconfig",
    vim.lsp.config("ruby_lsp", {
        cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
    }),
    vim.lsp.config("sorbet", {
        cmd = { vim.fn.expand("~/.rbenv/shims/srb"), "tc", "--lsp", "--disable-watchman" },
    }),
    vim.lsp.config("rubocop", {
        enabled = false,
    })
}
