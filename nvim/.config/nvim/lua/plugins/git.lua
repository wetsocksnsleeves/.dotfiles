return {
    { "tpope/vim-fugitive" },
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
            { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        }
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            local gitsigns = require("gitsigns")
            gitsigns.setup({
                vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame)
            })
        end
    },
    {
        "sindrets/diffview.nvim",
        config = function()
            require("diffview").setup({
                vim.keymap.set('n', '<leader>vd', function()
                    if next(require('diffview.lib').views) == nil then
                        vim.cmd('DiffviewOpen')
                    else
                        vim.cmd('DiffviewClose')
                    end
                end)
            })
        end
    }
}
