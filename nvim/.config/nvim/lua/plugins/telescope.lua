return {
    {
        "nvim-telescope/telescope.nvim",
        tag = '0.1.5',
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set('n', '<C-p>', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
            vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Find Symbols' })
            vim.keymap.set('n', '<leader>en', function()
                builtin.find_files {
                    cwd = vim.fn.stdpath("config")
                }
            end)
            vim.keymap.set('n', '<leader>fh', function()
                require('telescope.builtin').help_tags({
                    prompt_title = "Help",
                })
            end, { noremap = true, silent = true, desc = 'Search help documentation' })
        end
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {
                        }
                    }
                }
            })
            require("telescope").load_extension("ui-select")
        end
    }
}
