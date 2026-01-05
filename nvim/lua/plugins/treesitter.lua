return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    autoinstall = true,
    highlight = { enable = true },
    indent = { enable = true },
    folds = { enable = true },
    ensure_installed = {
      "bash",
      "c",
      "html",
      "json",
      "jsonc",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "rust",
      "toml",
      "yaml",
    },
  },
}
