return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            ensure_installed = { "lua", "javascript", "typescript", "tsx" },
            highlight = { enable = true },
            auto_install = true,
            autotag = { enable = true },
            indent = { enable = true },
        })
    end,
    dependencies = {
        'nvim-treesitter/nvim-treesitter-context',
    }
}
