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
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({})
			lspconfig.rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						cargo = {
							buildScripts = {
								enable = false,
							},
						},
						procMacro = {
							enable = false,
						},
						files = {
							exclude = { "**/magic_file.rs" },
						},
						-- server = {
						-- 	extraEnv = {
						-- 		RUST_ANALYZER_MEMORY_LIMIT = "2048",
						-- 	},
						-- },
					},
				},
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
