return {
    "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate",
    config = function() 
        local tree = require("nvim-treesitter.configs")
        tree.setup({
            ensure_installed = {"lua", "javascript"},
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
