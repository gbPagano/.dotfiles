return {
  "neovim-treesitter/nvim-treesitter",
  dependencies = { "neovim-treesitter/treesitter-parser-registry" },
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
      "bash",
      "c",
      "html",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "rust",
      "toml",
      "yaml",
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft) or ft
        if not pcall(vim.treesitter.language.add, lang) then
          return
        end
        pcall(vim.treesitter.start, buf, lang)

        if vim.treesitter.query.get(lang, "folds") then
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldmethod = "expr"
        end

        if vim.treesitter.query.get(lang, "indents") then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
