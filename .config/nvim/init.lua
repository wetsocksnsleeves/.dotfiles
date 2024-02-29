-- LAZY PACKAGE MANAGER --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- LAZY PLUGINS & OPTS --
local plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "rebelot/kanagawa.nvim", name = "kanagawa", priority = 1000}
}

local opts = {}

require("lazy").setup(plugins, opts) -- Load Lazy --
require("kanagawa").setup()
vim.cmd.colorscheme "kanagawa-dragon"

-- VIM PREFERENCES -- 
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set autoindent")
vim.cmd("set colorcolumn=80")
vim.cmd("highlight ColorColumn ctermbg=8 guibg=lightgrey")
vim.cmd("set number")
