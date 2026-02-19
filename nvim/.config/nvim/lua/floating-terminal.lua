-- Store the terminal buffer and window IDs
local term_buf = nil
local term_win = nil

-- Function to create a centered floating window
local function create_floating_window()
    -- Get editor dimensions
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    -- Calculate floating window size (80% of screen)
    local win_width = math.ceil(width * 0.8)
    local win_height = math.ceil(height * 0.8)

    -- Calculate position to center the window
    local col = math.ceil((width - win_width) / 2)
    local row = math.ceil((height - win_height) / 2) - 1

    -- Window configuration
    local opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = "rounded",
        title = " Terminal ",
        title_pos = "center"
    }

    return opts
end

-- Main toggle function (global so it can be called from keymaps)
function ToggleFloatTerminal()
    -- Check if terminal window exists and is valid
    if term_win and vim.api.nvim_win_is_valid(term_win) then
        -- Close the terminal window
        vim.api.nvim_win_close(term_win, true)
        term_win = nil
        return
    end

    -- Check if terminal buffer exists and is valid
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
        -- Reuse existing terminal buffer
        local win_opts = create_floating_window()
        term_win = vim.api.nvim_open_win(term_buf, true, win_opts)
    else
        -- Create new terminal buffer
        local win_opts = create_floating_window()
        term_buf = vim.api.nvim_create_buf(false, true)
        term_win = vim.api.nvim_open_win(term_buf, true, win_opts)

        -- Start terminal in the buffer
        vim.fn.termopen(vim.o.shell)
    end

    -- Set terminal-specific options
    vim.api.nvim_buf_set_option(term_buf, 'filetype', 'terminal')

    -- Enter insert mode automatically
    vim.cmd('startinsert')

    -- Set up autocmd to clean up when buffer is deleted
    vim.api.nvim_create_autocmd("BufDelete", {
        buffer = term_buf,
        callback = function()
            term_buf = nil
            term_win = nil
        end,
        once = true
    })

    -- Normal mode keybinds
    vim.api.nvim_buf_set_keymap(term_buf, 'n', '<Esc>', ':close<CR>',
        { noremap = true, silent = true })

    -- Terminal mode key binds
    vim.api.nvim_buf_set_keymap(term_buf, 't', '<C-c>',
        '<C-\\><C-n>:lua ToggleFloatTerminal()<CR>',
        { noremap = true, silent = true })

    vim.api.nvim_buf_set_keymap(term_buf, 't', '<leader>tt',
        '<C-\\><C-n>:lua ToggleFloatTerminal()<CR>',
        { noremap = true, silent = true })

    -- Terminal mode key binds for tmux navigation - pass through to terminal
    vim.api.nvim_buf_set_keymap(term_buf, 't', '<C-h>', '<C-h>',
        { noremap = true, silent = false })
    vim.api.nvim_buf_set_keymap(term_buf, 't', '<C-j>', '<C-j>',
        { noremap = true, silent = false })
    vim.api.nvim_buf_set_keymap(term_buf, 't', '<C-k>', '<C-k>',
        { noremap = true, silent = false })
    vim.api.nvim_buf_set_keymap(term_buf, 't', '<C-l>', '<C-l>',
        { noremap = true, silent = false })
end

-- Create the command
vim.api.nvim_create_user_command('ToggleFloatTerminal', ToggleFloatTerminal, {})

vim.keymap.set('n', '<leader>tt', ToggleFloatTerminal,
    { noremap = true, silent = true, desc = 'Toggle floating terminal' })
