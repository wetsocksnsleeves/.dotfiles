return
{
    -- {
    --     "folke/which-key.nvim",
    --     event = "VeryLazy",
    --     keys = {
    --         {
    --             "<leader>?",
    --             function()
    --                 require("which-key").show({ global = false })
    --             end,
    --             desc = "Buffer Local Keymaps (which-key)",
    --         },
    --     },
    -- },
    {
        "NStefan002/screenkey.nvim",
        lazy = false,
        version = "*", -- or branch = "main", to use the latest commit
    },
    {
        "sphamba/smear-cursor.nvim",
        config = function()
            require("smear_cursor").setup({
                cursor_color = "#ffffff",
                stifness = 0.9,
                trailing_stiffness = 0.8,
                distance_stop_animating = 0.3
            })
        end
    }
}
