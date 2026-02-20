return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    'nvim-treesitter/nvim-treesitter-context',
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    require("nvim-treesitter.config").setup({
      ensure_installed = { "lua", "javascript", "typescript", "tsx", "html", "embedded_template" },
      highlight = { enable = true },
      auto_install = true,
      indent = { enable = true },
    })

    require("nvim-treesitter-textobjects").setup({
      move = { set_jumps = true },
    })

    local move = require("nvim-treesitter-textobjects.move")
    vim.keymap.set({ "n", "x", "o" }, "]f", function()
      move.goto_next_start("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[f", function()
      move.goto_previous_start("@function.outer", "textobjects")
    end)
  end,
}
