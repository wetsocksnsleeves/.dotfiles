return {
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets', 'L3MON4D3/LuaSnip' },

        version = '1.*',

        config = function()
            local blink = require("blink.cmp")
            blink.setup({
                keymap = { preset = 'super-tab' },

                -- Use LuaSnip as the snippet engine so hand-written Lua
                -- snippets (see ~/.config/nvim/luasnippets) are available.
                snippets = { preset = 'luasnip' },

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
    {'L3MON4D3/LuaSnip',
        config = function()
            -- friendly-snippets (VSCode JSON) so existing completions keep working
            require("luasnip.loaders.from_vscode").lazy_load()
            -- hand-written Lua snippets under ~/.config/nvim/luasnippets/<filetype>.lua
            require("luasnip.loaders.from_lua").lazy_load({
                paths = { vim.fn.stdpath("config") .. "/luasnippets" },
            })
        end,
    },
}
