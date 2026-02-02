return {
    'nvim-mini/mini.nvim',
    version = '*',
    config = function()
        local surround = require('mini.surround')
        surround.setup(
            {
                mappings = {
                    add = 'ys', -- Add surrounding in Normal and Visual modes (vim-surround style)
                    delete = 'ds', -- Delete surrounding (vim-surround style)
                    find = 'yf', -- Find surrounding (to the right)
                    find_left = 'yF', -- Find surrounding (to the left)
                    highlight = 'yh', -- Highlight surrounding
                    replace = 'cs', -- Replace surrounding (vim-surround style)

                    suffix_last = 'l', -- Suffix to search with "prev" method
                    suffix_next = 'n', -- Suffix to search with "next" method
                },

            }
        )
    end
}
