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

-- '+' registry for WSL
local function is_wsl()
    local output = vim.fn.system("uname -r")
    return string.find(output, "WSL") ~= nil or string.find(output, "microsoft") ~= nil
end

if is_wsl() then
    vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
            ['+'] = 'clip.exe',
            ['*'] = 'clip.exe',
        },
        paste = {
            ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0,
    }
end

-- LOAD PLUGINS & OPTIONS --
require("vim-options")
require("lazy").setup("plugins")
require("lazy").setup(plugins, opts) -- Load Lazy --
