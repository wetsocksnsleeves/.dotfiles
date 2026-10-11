return {
    {
        'wetsocksnsleeves/coconut-oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        -- Optional dependencies
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
        config = function()
            local oil = require("oil")
            oil.setup({
                delete_to_trash = true,
                skip_confirm_for_simple_edits = true,
                -- Only prompt when the pending changes include a delete
                skip_confirm_for_delete = false,
                float = {
                    border = "rounded",
                    win_options = {
                        winblend = 25,
                        cursorline = true,
                        signcolumn = "no",
                    },
                }
            })
            vim.keymap.set("n", "-", oil.toggle_float, {})
        end,
    }
}
