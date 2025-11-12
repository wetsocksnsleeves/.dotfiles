return {
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").load("dragon")
        end
    },
    {
        "xiyaowong/transparent.nvim",
        dependencies = {
            "rebelot/kanagawa",
        },
        config = function()
            vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {},
                { "FloatBorder", "NormalFloat", "TelescopeBorder"})

            -- Hot fix for kanagawa dragon
            local M = require("transparent")
            local original_toggle = M.toggle

            M.toggle = function(opt)
              original_toggle(opt)

              -- Explicitly reload the *Dragon* variant
              vim.cmd.colorscheme("kanagawa-dragon")

              -- Re-clear Kanagawa backgrounds
              require("transparent").clear_prefix("kanagawa")
            end
        end,
    },
}
