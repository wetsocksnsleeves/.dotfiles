return {
    {
        "rebelot/kanagawa.nvim",
    },
    {
        dir = vim.fn.expand("~/Code/bleakvoid.nvim/")
    },
    {
        "slugbyte/lackluster.nvim",
        lazy = false,
    },
    {
        "xiyaowong/transparent.nvim",
        dependencies = {
            "rebelot/kanagawa.nvim",
        },
        lazy = false,
        config = function()
            vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {},
                { "FloatBorder", "NormalFloat", "TelescopeBorder", "BlinkCmpMenuBorder", "BlinkCmpMenu" })
        end,
    },
}
