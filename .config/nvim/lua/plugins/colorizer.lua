return {
    {
        -- Tailwind color previews within the completion window
        "roobert/tailwindcss-colorizer-cmp.nvim",
    },
    {
        -- Nice to have when needed run "ColorizerToggle"
        'norcalli/nvim-colorizer.lua',
        config = function()
            require 'colorizer'.setup({
            })
        end
    },
}
