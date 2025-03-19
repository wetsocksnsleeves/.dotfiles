return {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    priority = 1000,
    config = function()
        vim.cmd.colorscheme "kanagawa-dragon"
        vim.cmd("highlight LineNr guibg=none")
        vim.cmd("highlight Normal guibg=none")
    end
}
