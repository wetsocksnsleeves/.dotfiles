return {
  "tpope/vim-rails",
  {
      "kalebhenrique/lazyrails.nvim",
      ft = { "ruby", "eruby" },
      dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
      },
      opts = {}, -- see Configuration section below
    },
}
