-- Lazy setup
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

-- Disable inlay hints
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
})

vim.diagnostic.config({
    underline = true,         -- Enable underlines
    virtual_text = false,     -- Disable virtual text (if you don't want it)
    signs = true,             -- Enable signs in the sign column
    update_in_insert = false, -- Prevent diagnostics from updating during insert mode
    severity_sort = true,     -- Sort diagnostics by severity
})

-- Load plugins, vim options, and lazy configuration
require("vim-options")
require("lsp-config")
require("lazy").setup(
    "plugins",
    {
        spec = {},
        ui = {
            border = "rounded",
            title = nil, ---@type string only works when border is not "none"
            title_pos = "center", ---@type "center" | "left" | "right"
        }
    }
)
require("floating-terminal")
