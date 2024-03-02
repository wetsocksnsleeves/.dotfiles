return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "clangd", "clang-format", "pyright", "mypy", "pylint" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
        lazy = false,
		config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })
			lspconfig.clangd.setup({
				capabilities = capabilities,
				cmd = { "clangd", "--clang-tidy" },
			})
            lspconfig.pyright.setup({
                capabilities = capabilities,
                filetypes = {"python"}
            })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		end,
	},
}
