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
            gitsigns.setup()
            vim.keymap.set('n', '<leader>tb', gitsigns.blame, { desc = "Get current line blame" })
            vim.keymap.set('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = "Get current word diff" })

            vim.keymap.set('n', '<leader>hq', function()
                gitsigns.setqflist()
            end, { desc = "Quickfix hunks in this file" })
            vim.keymap.set('n', '<leader>hQ', function()
                gitsigns.setqflist("all")
            end, { desc = "Quickfix hunks in all changed files" })
            vim.keymap.set('n', '<leader>hc', require("quickfix").changed_files,
                { desc = "Quickfix files changed vs branch base" })
            vim.keymap.set('n', '<leader>hb', function()
                gitsigns.change_base(nil, true)
                vim.notify("Diff base reset to index")
            end, { desc = "Reset diff base to index" })
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
                end, { desc = "Show git diff" }),
                vim.keymap.set('n', '<leader>vp', function()
                    if next(require('diffview.lib').views) == nil then
                        vim.cmd('DiffviewOpen origin/master...HEAD')
                    else
                        vim.cmd('DiffviewClose')
                    end
                end, { desc = "Show branch diff (PR view)" })
            })
        end
    },
    {"github/copilot.vim"},
}
