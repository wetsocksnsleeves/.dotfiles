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
                vim.keymap.set('n', '<leader>tb', gitsigns.blame, { desc = "Get current line blame" }),
                vim.keymap.set('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = "Get current word diff" })
            })
        end
    },
    {
        'axkirillov/unified.nvim',
        opts = {},
        keys = {
            {
                '<leader>vd',
                function() require('unified').toggle() end,
                desc = "Show git diff",
            },
            {
                '<leader>vp',
                function()
                    if require('unified.state').is_active() then
                        vim.cmd('Unified reset')
                    else
                        vim.cmd('Unified origin/master')
                    end
                end,
                desc = "Show branch diff (PR view)",
            },
        },
    },
    {"github/copilot.vim"},
}
