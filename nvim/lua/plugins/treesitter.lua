return {
  "nvim-treesitter/nvim-treesitter",
  commit = "4916d6592ede8c07973490d9322f187e07dfefac",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    'nvim-treesitter/nvim-treesitter-context',
    "windwp/nvim-ts-autotag",
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function()
    local ts = require("nvim-treesitter")
    ts.setup()

    -- On the `main` branch there is no module system: parsers are installed
    -- with install() and highlight/indent are enabled manually (see autocmd).
    ts.install({
      "lua", "javascript", "typescript", "tsx",
      "html", "embedded_template", "ruby", "css",
    })

    -- Enable highlighting + indent for any buffer whose filetype has an
    -- installed parser. embedded_template covers .html.erb (ft=eruby).
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
        if not lang then
          return
        end
        if not pcall(vim.treesitter.start, ev.buf, lang) then
          return
        end
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
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
