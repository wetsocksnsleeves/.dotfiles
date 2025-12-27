return {
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },

        version = '1.*',

        config = function()
            local blink = require("blink.cmp")
            blink.setup({
                keymap = { preset = 'super-tab' },

                appearance = {
                    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                    -- Adjusts spacing to ensure icons are aligned
                    nerd_font_variant = 'mono'
                },

                -- Show the documentation pop ups
                completion = {
                    documentation = { auto_show = true },
                    menu = {
                        border = "rounded",
                    },
                    -- list = {
                    --     selection = {
                    --         preselect = false,
                    --     },
                    -- },
                },

                -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
                fuzzy = { implementation = "prefer_rust_with_warning" },
            })
        end,
    },
}
