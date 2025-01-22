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

-- For Deno
vim.g.markdown_fenced_languages = {
    "ts=typescript"
}

-- For Wsl
vim.g.clipboard = {
    name = 'win32yank',
    copy = {
        ['+'] = 'win32yank.exe -i',
        ['*'] = 'win32yank.exe -i',
    },
    paste = {
        ['+'] = 'win32yank.exe -o',
        ['*'] = 'win32yank.exe -o',
    },
}

-- LOAD PLUGINS & OPTIONS --
require("vim-options")
require("lazy").setup("plugins")
require("lazy").setup(plugins, opts) -- Load Lazy --
