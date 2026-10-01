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
            },
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignore = false,
                },
            }
        })
    end
}
