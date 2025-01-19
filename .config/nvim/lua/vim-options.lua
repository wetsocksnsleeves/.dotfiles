vim.g.mapleader = " "
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set autoindent")
vim.cmd("set colorcolumn=80")
vim.cmd("highlight ColorColumn ctermbg=8 guibg=lightgrey")
vim.cmd("set number")
vim.diagnostic.config({ update_in_insert = true })
vim.wo.relativenumber=true
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Useful remaps --
vim.keymap.set('n', "<F5>", ":!python3 %<CR>")
vim.keymap.set('n', "<leader>fx", ":!chmod +x %<CR>")
vim.keymap.set('n', '<leader>fr', ':%s//g<left><left>', { noremap = true })
