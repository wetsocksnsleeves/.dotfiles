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

-- Useful remaps
vim.keymap.set('n', "<F5>", ":!python3 %<CR>")
vim.keymap.set('n', "<leader>fx", ":!chmod +x %<CR>")
vim.keymap.set('n', '<leader>fr', ':%s//g<left><left>', { noremap = true })

-- Compiler.nvim keymaps (Doesn't work unless in here for some reason)

-- Open compiler
vim.keymap.set("n", "<F6>", ":CompilerOpen<CR>", { noremap = true, silent = true })

-- Redo last selected option
vim.keymap.set(
	"n",
	"<S-F6>",
	"<cmd>CompilerStop<cr>" -- (Optional, to dispose all tasks before redo)
		.. "<cmd>CompilerRedo<cr>",
	{ noremap = true, silent = true }
)

-- Toggle compiler results
vim.keymap.set("n", "<S-F7>", "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })
