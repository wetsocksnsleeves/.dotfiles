return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "javascript", "typescript", "tsx", "html", "embedded_template" },
            highlight = { enable = true },
            auto_install = true,
            indent = { enable = true },
        })
    end,
    dependencies = {
        'nvim-treesitter/nvim-treesitter-context',
        "windwp/nvim-ts-autotag"
    },
}
