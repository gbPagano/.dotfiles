return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			autoinstall = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
