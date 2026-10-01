return {
    "christoomey/vim-tmux-navigator",
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
    },
    keys = {
        { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Switch to left pane" },
        { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Switch to below pane" },
        { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Switch to above pane" },
        { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Switch to right pane" },
    },
}
