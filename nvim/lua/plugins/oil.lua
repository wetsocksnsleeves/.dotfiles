return {
    {
        'stevearc/oil.nvim',
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
