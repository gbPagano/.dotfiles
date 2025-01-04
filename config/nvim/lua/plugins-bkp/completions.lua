return {
	-- {
	-- 	-- nvim-cmp source for neovim's built-in language server client
	-- 	"hrsh7th/cmp-nvim-lsp",
	-- },
	-- {
	-- 	-- snippet engine plugin
	-- 	"L3MON4D3/LuaSnip",
	-- 	dependencies = {
	-- 		"saadparwaiz1/cmp_luasnip",
	-- 		"rafamadriz/friendly-snippets",
	-- 	},
	-- },
	-- {
	--   -- completion engine plugin
	--   "hrsh7th/nvim-cmp",
	--   config = function()
	--     local cmp = require("cmp")
	--     require("luasnip.loaders.from_vscode").lazy_load()
	--
	--     cmp.setup({
	--       snippet = {
	--         expand = function(args)
	--           require("luasnip").lsp_expand(args.body)
	--         end,
	--       },
	--       window = {
	--         completion = cmp.config.window.bordered(),
	--         documentation = cmp.config.window.bordered(),
	--       },
	--       mapping = cmp.mapping.preset.insert({
	--         ["<C-k>"] = cmp.mapping.scroll_docs(-4),
	--         ["<C-j>"] = cmp.mapping.scroll_docs(4),
	--         ["<C-e>"] = cmp.mapping.abort(),
	--         ["<CR>"] = cmp.mapping.confirm({ select = true }),
	--       }),
	--       sources = cmp.config.sources({
	--         { name = "nvim_lsp" },
	--         { name = "luasnip" }, -- For luasnip users.
	--       }, {
	--         { name = "buffer" },
	--       }),
	--     })
	--   end,
	-- },
	-- {
	-- 	"saghen/blink.cmp",
	-- 	dependencies = "rafamadriz/friendly-snippets",
	-- 	version = "v0.*",
	-- 	opts = {
	-- 		keymap = { preset = "enter" },
	--
	-- 		appearance = {
	-- 			use_nvim_cmp_as_default = false,
	-- 			nerd_font_variant = "mono",
	-- 		},
	--
	-- 		sources = {
	-- 			default = { "lsp", "path", "snippets", "buffer" },
	-- 		},
	--      signature = { enabled = true }
	-- 	},
	-- 	opts_extend = { "sources.default" },
	-- },
}
