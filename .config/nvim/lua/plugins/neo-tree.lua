return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons", 
          "MunifTanjim/nui.nvim"
    },
    config = function()
        require('neo-tree').setup({
            visible = true,
            close_if_last_window = true,
            window = {
                position = "right",
            }
        })
        vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal right<CR>')
        vim.keymap.set('n', '<C-h>', ':Neotree filesystem reveal toggle<CR>')
    end
}
