vim.g.mapleader = " "

vim.opt.termguicolors = true
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set autoindent")
vim.cmd("set colorcolumn=80")
vim.cmd("set number")
vim.wo.relativenumber = true

vim.opt.spell = true
vim.opt.spelllang = "en_us"
vim.opt.scrolloff = 8
vim.opt.splitright = true

vim.diagnostic.config({ update_in_insert = true })

------ REMAPS ------

-- Quick python run
vim.keymap.set('n', "<F5>", ":!python3 %<CR>")

-- Quick script permissions
vim.keymap.set('n', "<leader>fx", ":!chmod +x %<CR>")

-- Move through wrapped lines like normal
vim.keymap.set('n', 'k', function()
    return vim.v.count == 0 and 'gk' or 'k'
end, { expr = true })

vim.keymap.set('n', 'j', function()
    return vim.v.count == 0 and 'gj' or 'j'
end, { expr = true })

-- Copy pasta
vim.keymap.set("x", "<leader>p", "\"_dP")         -- paste without resetting buffer
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')  -- yank to clipboard
vim.keymap.set({ "n", "v" }, "<leader>yy", '"+y') -- yank line to clipboard
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')  -- delete without overriding buffer
vim.keymap.set({ "n", "v" }, "<leader>dd", '"_d') -- delete line without overriding buffer

-- Find and replace + Un-highlight
vim.keymap.set('n', '<leader>fr', ':%s//g<left><left>', { noremap = true })
vim.keymap.set('n', "<leader>nh", ":noh<CR>")

-- Line movement with indent
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor in middle while search
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Keep cursor in middle while jumping by half a page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- f+d to Esc
vim.keymap.set({"i", "v"}, "fd", "<Esc>")
vim.keymap.set({"i", "v"}, "<C-c>", "<Esc>")
