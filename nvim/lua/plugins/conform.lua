return {
  "stevearc/conform.nvim",
  lazy = false,
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      rust = { "rustfmt" },
    },
    format_on_save = {
      lsp_format = "fallback",
      async = false,
      timeout_ms = 500,
    },
  },
  keys = {
    {
      "<leader>gf",
      function()
        require("conform").format({
          lsp_format = "fallback",
          async = false,
          timeout_ms = 1000,
        })
      end,
      mode = { "n", "v" },
      desc = "Format file or range (in visual mode)",
    },
  },
}
