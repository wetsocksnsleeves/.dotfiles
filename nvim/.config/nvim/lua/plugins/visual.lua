return {
    "sphamba/smear-cursor.nvim",
    config = function()
        require("smear_cursor").setup({
            cursor_color = "#ffffff",
            stifness = 0.9,
            trailing_stiffness = 0.8,
            distance_stop_animating = 0.3
        })
    end
}
