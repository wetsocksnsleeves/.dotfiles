return {
    {
        "xiyaowong/transparent.nvim",
        config = function()
            require("transparent").setup({
                extra_groups = { "FloatBorder", "NormalFloat", "TelescopeBorder" },
            })
            vim.cmd("highlight LazyH1 guifg=#ffffff")
        end
    },
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme "kanagawa-dragon"
        end
    }
}
